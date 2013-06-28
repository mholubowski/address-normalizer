# Look http://datamapper.org/docs/associations.html many-to-many

class AddressNormalizer < Sinatra::Base
  enable :sessions

  # SETTINGS
  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, 'public')
  set :assets_folder, File.join(root, 'assets')
  set :sprockets, Sprockets::Environment.new(root)

  # CONFIGURATION
  configure :test do

  end

  configure :development do 
    # DataMapper::Logger.new(STDOUT, :debug) unless ENV['running_rspec'] || false
    # DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/address_normalizer.db")
    register Sinatra::Reloader
  end

  configure :production do
    # DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
  end

  configure do 
    set :session_secret, '12345'
    set :session_fail, '/login'
    register Sinatra::Session
    
    sprockets.append_path "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"
    sprockets.append_path File.join(assets_folder, 'javascripts')
    sprockets.append_path File.join(assets_folder, 'stylesheets')
    sprockets.append_path File.join(assets_folder, 'images')
  end
  
  configure :production, :test do
    #sprockets.css_compressor = YUI::CssCompressor.new
    sprockets.js_compressor = Uglifier.new
  end

  # Includes
  require_relative 'models/address_set'
  require_relative 'models/tokenized_address'

  # DataMapper.finalize

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
    #display all address sets
    @@list ||= []
    @list = @@list
    erb :normalize
  end

  post '/upload' do 
    # File.open('uploads/' + params['thefile'][:filename], "w") do |f|
    #   f.write(params['thefile'][:tempfile].read)
    # end
    @@list << 'test'
    redirect to('/normalize')
    return "The file was successfully uploaded!"
  end

  post '/address_set/new' do
    redirect to('/normalize')
  end

  get '/download/:filename' do
    file = params[:filename]
    send_file "./uploads/#{file}", filename: file, type: 'Application/octet-stream'
  end

  get '/tester' do
    return session[:username]
  end

end
