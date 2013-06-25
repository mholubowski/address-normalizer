# Set rack environment to TEST
ENV['RACK_ENV'] = 'test'

# Require Bundler and require all necessary gems
require 'bundler'
Bundler.require :default, :test

# Start SimpleCov for code coverage report.
SimpleCov.start

# Include our application.
require_relative '../app'

# Set up Capybara with our application.
Capybara.app = AddressNormalizer
