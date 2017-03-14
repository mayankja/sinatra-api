require "rubygems"
require "bundler"

Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems

require "active_support/deprecation"
require "active_support/all"
require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/base'
require 'sinatra/reloader'
require 'bundler/setup'
require 'yaml'
require 'byebug'
require 'sinatra/strong-params'
require "sinatra/json"
require "twilio-ruby"
require "mongoid"

%w[models config app mailer].each do |dir|
  Dir.glob("./#{dir}/*.rb").each do |relative_path|
    require relative_path
  end
end

ENV = YAML.load(ERB.new(File.read("./config/application.yml")).result)[RACK_ENV || "development"]

configure do
  Mongoid.load!("./config/database.yml", RACK_ENV || "development")
end