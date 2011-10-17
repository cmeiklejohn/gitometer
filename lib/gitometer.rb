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

      def user
        env['warden'].user
      end
    end

    get '/' do
      ensure_authenticated
      "Hello There, #{user.name}!"
    end

    get '/redirect_to' do
      ensure_authenticated
      "Hello There, #{user.name}! return_to is working!"
    end

    get '/auth/github/callback' do
      ensure_authenticated
      redirect '/'
    end

    get '/logout' do
      env['warden'].logout
      "Peace!"
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
