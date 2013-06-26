# coding: utf-8

class AddressNormalizer < Sinatra::Base
  enable :sessions

  # SETTINGS
  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, 'public')
  set :assets_folder, File.join(root, 'assets')
  set :sprockets, Sprockets::Environment.new(root)

  # CONFIGURATION
  configure do 
    set :session_secret, '12345'
    
    sprockets.append_path "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"
    sprockets.append_path File.join(assets_folder, 'javascripts')
    sprockets.append_path File.join(assets_folder, 'stylesheets')
    sprockets.append_path File.join(assets_folder, 'images')
  end
  
  configure :production, :test do
    #sprockets.css_compressor = YUI::CssCompressor.new
    sprockets.js_compressor = Uglifier.new
  end

  # ROUTES
  get '/' do
    @title = 'Hello, World!'

    erb :index
  end

  get '/info' do 
    erb :info
  end

  get '/normalize' do
    erb :normalize
  end

  post '/upload' do 
    File.open('uploads/' + params['thefile'][:filename], "w") do |f|
      f.write(params['thefile'][:tempfile].read)
    end
    return "The file was successfully uploaded!"
  end

  get '/download/:filename' do
    file = params[:filename]
    send_file "./uploads/#{file}", filename: file, type: 'Application/octet-stream'
  end

end
