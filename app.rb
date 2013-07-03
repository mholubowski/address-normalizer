class AddressNormalizer < Sinatra::Base

  enable :sessions

  # SETTINGS
  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, 'public')
  set :assets_folder, File.join(root, 'assets')
  set :sprockets, Sprockets::Environment.new(root)

  configure do
    set :session_secret, '12345'
    set :session_fail, '/login'
    register Sinatra::Session

    sprockets.append_path "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"
    sprockets.append_path File.join(assets_folder, 'javascripts')
    sprockets.append_path File.join(assets_folder, 'stylesheets')
    sprockets.append_path File.join(assets_folder, 'images')
  end

  configure :development do
    register Sinatra::Reloader
  end

  configure :production do
    sprockets.css_compressor = YUI::CssCompressor.new
    sprockets.js_compressor = Uglifier.new
  end

  # Includes
  models = %w(address_set tokenized_address file_parser current_user file_exporter)
  models.each {|file| require_relative "models/#{file}"}

  require_relative 'helpers'
  require_relative 'support/redis_db'

  require "csv"

  # sets global for RedisDb singleton
  $redis = RedisDb.instance

  # ROUTES
  get '/' do
    @title = 'Address Normalizer'
    erb :index
  end

  get '/login' do
    redirect to('/') if session?
    erb :login
  end

  post '/login' do
    if params[:username]
      session_start!
      session[:username] = params[:username]
      redirect to('/')
    else
      redirect to('/login')
    end
  end

  get '/logout' do
    session_end!
    redirect to('/')
  end

  get '/info' do
    erb :info
  end

  get '/normalize' do
    enforce_logged_in
    #display all address sets
    @sets = []
    CurrentUser::set_ids.each {|id| @sets << AddressSet.find(id) }
    erb :normalize
  end

  post '/upload' do
    @@parser ||= FileParser.new
    # File.open('uploads/' + params['thefile'][:filename], "w") do |f|
    #   f.write(params['thefile'][:tempfile].read)
    # end
    file = params['thefile'][:tempfile]
    set = @@parser.create_address_set({filename: file})
    set.save
    redirect to('/normalize')
  end

  post '/address_set/new' do
    redirect to('/normalize')
  end

  get '/address_set/:redis_id/view/:type' do
    type = params[:type]
    @set = AddressSet.find(params[:redis_id])
    return erb :"AddressSet/_widget" if type == 'widget'
    return erb :"AddressSet/main"
  end

  get '/download/:filename' do
    file = params[:filename]
    send_file "./uploads/#{file}", filename: file, type: 'Application/octet-stream'
  end

  get '/address_set/:redis_id/simple-export' do
    @set = AddressSet.find(params[:redis_id])
    # FileExporter.instance.simple_export(@set)
    # @set.to_csv
    csv_content = @set.to_csv

    headers "Content-Disposition" => "attachment;filename=#{"temp"}",
            "Content-Type" => "text/csv"
    csv_content
  end

  delete '/address_set/:redis_id' do
    redis_id = params[:redis_id].to_i
    CurrentUser::set_ids.delete(redis_id)
    redirect back unless request.xhr?
    # erb :"AddressSet/main"
  end

  get '/tester' do
    return session[:username]
  end

end
