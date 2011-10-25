require 'spec_helper'

module Gitometer
  class GithubHelped; include GithubHelpers; end

  describe GithubHelpers do 
    subject { GithubHelped.new } 

    it 'returns the proper endpoint' do 
      subject.endpoint.should == 'https://api.github.com'
    end

    let(:user) { mock('user', :token => 1) }

    it 'can parameterize the access token' do 
      subject.access_token_param_for_user(user).should == "access_token=1"
    end

    it 'can paramterize the page' do 
      subject.param_for_page(1).should == "page=1"
    end

    pending 'retrieves the repositories for a user' 

    pending 'retrieves the commits for a users repository' 

    pending 'can convert the commit list into a count by day hash'
  end
end
