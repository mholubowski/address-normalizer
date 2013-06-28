# Set rack environment to TEST


# Require Bundler and require all necessary gems
require 'bundler'
Bundler.require :default, :test

# Start SimpleCov for code coverage report.
# SimpleCov.start

# Include our application.
ENV['running_rspec'] = 'true'
require_relative '../app'
ENV['RACK_ENV'] = 'test'

# require 'rack/test'

RSpec.configure do |config|
  # config.include Rack::Test::Methods
  # DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/test_address_normalizer.db")
  # DataMapper.finalize
	# DataMapper.auto_migrate!
end

# Set up Capybara with our application.
# Capybara.app = AddressNormalizer
