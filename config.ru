require 'bundler'
Bundler.require

require './app'

map '/assets' do
    run AddressNormalizer.sprockets
end

map '/' do
    run AddressNormalizer
end