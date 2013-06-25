require 'bundler'
Bundler.require

# Require sprockets task
require 'rake/sprocketstask'

# Require sinatra applicaton
require './app'

# Get path to the public assets folder
target = File.join(AddressNormalizer.public_folder, File.basename(AddressNormalizer.assets_folder))

namespace :sprockets do
  # Create new sprockets rake task
  Rake::SprocketsTask.new do |t|
    t.environment = AddressNormalizer.sprockets
    t.output      = target
    t.assets      = %w( application.js application.css )
  end
end