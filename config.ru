ENV['RACK_ENV'] ||= 'development'

begin
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

$LOAD_PATH << File.dirname(__FILE__) + '/lib'

Bundler.require

require 'sinatra'
require 'gitometer'

run Gitometer::Application
