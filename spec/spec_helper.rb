require 'simplecov'
SimpleCov.start do
  add_filter '/config/'
  add_filter '/spec/'
  add_filter '/models/'
  add_filter '/mailer/'
end

RACK_ENV = "test"
Bundler.require :default, :test
require File.join(File.dirname(__FILE__), "..", "./config/environment.rb")
require "rack/test"
require "rspec"
require 'database_cleaner'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end