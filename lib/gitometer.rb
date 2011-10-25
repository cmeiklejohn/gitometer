# encoding: UTF-8

require 'rubygems'
require 'bundler'
require 'sinatra'

require 'warden'
require 'warden-github'

require 'rest_client'
require 'json'

require 'time'

module Gitometer
  autoload :GithubHelpers, 'gitometer/github_helpers'
  autoload :WardenHelpers, 'gitometer/warden_helpers'

  class Application < Sinatra::Base
    enable  :sessions
    enable  :logging
    enable  :raise_errors
    disable :show_exceptions

    if ENV["RACK_ENV"] == 'development'
      set :session_secret, 'fixed'
    end

    use Warden::Manager do |manager|
      manager.default_strategies :github
      manager.failure_app = BadAuthentication

      manager[:github_client_id]    = ENV['GITHUB_CLIENT_ID']
      manager[:github_secret]       = ENV['GITHUB_CLIENT_SECRET']

      manager[:github_scopes]       = 'email,offline_access'
      manager[:github_callback_url] = '/auth/github/callback'
    end

    helpers do
      include Gitometer::GithubHelpers
      include Gitometer::WardenHelpers
    end

    get '/' do
      todays_date     = Time.now.utc.strftime("%Y-%m-%d")
      yesterdays_date = (Time.now.utc - 86400).strftime("%Y-%m-%d")

      if authenticated?
        commits = repositories_for_user(user).map do |repository|
          commits_for_user_and_repository(user, repository)
        end
        commits = commits_to_daily_count(commits)

        @todays_commits     = commits[todays_date] || 0 
        @yesterdays_commits = commits[yesterdays_date] || 0 
      end

      erb :index
    end

    get '/commits.json' do 
      content_type :json
      if authenticated?
        commits = repositories_for_user(user).map do |repository|
          commits_for_user_and_repository(user, repository)
        end
        commits = commits_to_daily_count(commits)
        commits.to_json
      end
    end

    get '/login' do 
      ensure_authenticated
      redirect '/'
    end

    get '/redirect_to' do
      ensure_authenticated
      "Redirect to is working!"
    end

    get '/auth/github/callback' do
      ensure_authenticated
      redirect '/'
    end

    get '/logout' do
      logout!
      redirect '/'
    end
  end

  class BadAuthentication < Sinatra::Base
    get '/unauthenticated' do
      status 403
      "Unable to authenticate, sorry bud."
    end
  end

  def self.app
    @app ||= Rack::Builder.new do
      run Application
    end
  end
end
