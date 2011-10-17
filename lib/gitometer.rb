module Gitometer
  class Application < Sinatra::Base
    enable :sessions

    register Sinatra::Auth::Github

    set :github_options, {
      :secret    => ENV['GITHUB_CLIENT_SECRET'],
      :client_id => ENV['GITHUB_CLIENT_ID']
    }

    get '/' do 
      erb :index
    end
  end
end
