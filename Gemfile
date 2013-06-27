source "https://rubygems.org"

gem 'sinatra', require: 'sinatra/base'
gem 'sinatra-contrib', require: 'sinatra/contrib'
gem 'sinatra-named-routes', require: 'sinatra/named_routes'
gem 'sprockets'
gem 'sass'
gem 'compass'
gem 'bootstrap-sass', '~> 2.3.2.0'
gem 'uglifier'
gem 'pry'
gem 'StreetAddress', :require => "street_address"

gem "dm-core"
gem "dm-migrations"
gem "pg", group: :production
gem "dm-postgres-adapter", group: :production
gem "dm-sqlite-adapter", group: :development

gem 'thin'

# gem 'unicorn'

group :development, :test do
	gem 'shotgun'
	gem 'rspec'
	gem 'capybara', require: 'capybara/rspec'
	gem 'rack-test'
	gem 'guard'
	gem 'guard-rspec'
	gem 'simplecov'
end
