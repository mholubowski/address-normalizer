# Look http://datamapper.org/docs/associations.html many-to-many

class AddressNormalizer < Sinatra::Base
  enable :sessions


  # SETTINGS
  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, 'public')
  set :assets_folder, File.join(root, 'assets')
  set :sprockets, Sprockets::Environment.new(root)

  configure :development do 
    register Sinatra::Reloader
  end

  configure :production do

  end

  configure do 
    set :session_secret, '12345'
    set :session_fail, '/login'
    register Sinatra::Session
    
    sprockets.append_path "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"
    sprockets.append_path File.join(assets_folder, 'javascripts')
    sprockets.append_path File.join(assets_folder, 'stylesheets')
    sprockets.append_path File.join(assets_folder, 'images')

    REDISTOGO_URL = "redis://localhost:6379/"
    uri = URI.parse(REDISTOGO_URL)
    # $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end
  
  configure :production, :test do
    sprockets.css_compressor = YUI::CssCompressor.new
    sprockets.js_compressor = Uglifier.new
  end

  # Includes
  require_relative 'models/address_set'
  require_relative 'models/tokenized_address'
  require_relative 'models/file_parser'
  require_relative 'helpers'
  require_relative 'support/redis_db'

  # include RedisModule
  $redis = RedisDb.instance

  # ROUTES
  get '/' do
    @title = 'Hello, World!'
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
    erb :normalize
  end

  post '/upload' do 
    @@parser ||= FileParser.new
    # File.open('uploads/' + params['thefile'][:filename], "w") do |f|
    #   f.write(params['thefile'][:tempfile].read)
    # end
    file = params['thefile'][:tempfile]
    set = @@parser.create_address_set(file)
    # @redis.lpush('sets', set.to_json)
    redirect to('/normalize')
  end

  post '/address_set/new' do
    redirect to('/normalize')
  end

  get '/download/:filename' do
    file = params[:filename]
    send_file "./uploads/#{file}", filename: file, type: 'Application/octet-stream'
  end

  delete '/address_set/:hash' do
    hash = params[:hash].to_i
    session[:address_sets].destroy_set_by_hash(hash)
    redirect back unless request.xhr?
    erb :normalize
  end

  get '/tester' do
    return session[:username]
  end



end
