ENV['RACK_ENV'] ||= 'development'

require 'rubygems'
require 'bundler'
Bundler.setup

$LOAD_PATH << File.dirname(__FILE__) + '/lib'

Bundler.require

require 'sinatra'
require 'gitometer'

run Gitometer.app
