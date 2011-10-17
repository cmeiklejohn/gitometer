# encoding: UTF-8

ENV['RACK_ENV'] ||= 'development'

$LOAD_PATH << File.dirname(__FILE__) + '/lib'

require 'gitometer'

run Gitometer.app
