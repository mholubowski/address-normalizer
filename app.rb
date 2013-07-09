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
  models = %w(address_set tokenized_address file_parser current_user api_address_verifier)
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
    @sets = CurrentUser::address_sets
    erb :normalize
  end

  post '/upload' do
    File.open('uploads/' + params['thefile'][:filename], "w") do |f|
      f.write(params['thefile'][:tempfile].read)
    end
    file = 'uploads/' + params['thefile'][:filename]
    set = FileParser.instance.create_address_set({filename: file})
    set.save
    redirect to('/normalize')
  end

  get '/address_set/:redis_id/view/:type' do
    type = params[:type]
    @set = AddressSet.find(params[:redis_id])

    case type
    when 'widget'
      return erb :"AddressSet/_widget"
    else
      return erb :"AddressSet/main"
    end
  end

  get '/address_set/:redis_id/simple-export' do
    @set = AddressSet.find(params[:redis_id])
    csv_content = @set.simple_export

    filename = "normalized_"+@set.stats[:filename]
    send_csv({content: csv_content, filename: filename})
  end

  get '/address_set/:redis_id/addon-export' do
    @set = AddressSet.find(params[:redis_id])
    csv_content = @set.addon_export

    filename = "normalized_"+@set.stats[:filename]
    send_csv({content: csv_content, filename: filename})
  end

  get '/address_set/:redis_id/addon-seperate-columns' do
    @set = AddressSet.find(params[:redis_id])
    csv_content = @set.addon_seperate_columns

    filename = "normalized_"+@set.stats[:filename]
    send_csv({content: csv_content, filename: filename})
  end

  get '/address_set/:redis_id/addon-verified-columns' do
    @set = AddressSet.find(params[:redis_id])
    csv_content = @set.addon_verified_columns

    filename = "normalized_"+@set.stats[:filename]
    send_csv({content: csv_content, filename: filename})
  end

  get '/address_set/:redis_id/verify' do
    @set = AddressSet.find(params[:redis_id])
    @set.verified_addresses.clear
    @set.verify_addresses
    @set.save_verified_addresses

    @set = AddressSet.find(params[:redis_id])
    redirect to('/normalize')
  end

  delete '/address_set/:redis_id' do
    redis_id = params[:redis_id].to_i
    CurrentUser::set_ids.delete(redis_id)
    redirect back unless request.xhr?
  end

  get '/tester' do
    return session[:username]
  end

end
