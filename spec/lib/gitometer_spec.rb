require 'spec_helper'

describe Gitometer do
  subject { Gitometer.app }

  it 'responds to /' do
    get '/'
    last_response.should be_ok
  end

  it 'responds to /login' do 
    get '/login'
    last_response.should be_redirect
  end

  it 'responds to /logout' do 
    get '/logout'
    last_response.should be_redirect
  end

  it 'responds to /auth/github/callback' do 
    get '/auth/github/callback'
    last_response.should be_redirect
  end
end
