# encoding: UTF-8

require 'rubygems'
require 'bundler'
require 'sinatra'
require 'warden'

module Gitometer
  class Application < Sinatra::Base
    enable  :sessions
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
      def ensure_authenticated
        unless env['warden'].authenticate!
          throw(:warden)
        end
      end

      def authenticated?
        env['warden'].authenticated?
      end

      def logout!
        env['warden'].logout
      end

      def user
        env['warden'].user
      end

      def github_profile_page(user)
        "http://github.com/#{user.login}"
      end
    end

    get '/' do
      erb :index
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
