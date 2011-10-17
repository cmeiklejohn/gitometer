require 'rubygems/package_task'
require 'rubygems/specification'
require 'date'
require 'bundler'
require 'rspec/core/rake_task'

task :default => [:spec]

RSpec::Core::RakeTask.new(:core) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--backtrace']
end
