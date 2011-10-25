require 'spec_helper'

module Gitometer
  class GithubHelped; include GithubHelpers; end

  describe GithubHelpers do 
    subject { GithubHelped.new } 

    it 'returns the proper endpoint' do 
      subject.endpoint.should == 'https://api.github.com'
    end

    context 'with a user' do 
      let(:user) { mock('user', :token => 1, :login => 'cmeik') }

      include_context 'a valid github repository response'
      include_context 'a valid github commit response'

      it 'can parameterize the access token' do 
        subject.access_token_param_for_user(user).should == "access_token=1"
      end

      it 'can paramterize the page' do 
        subject.param_for_page(1).should == "page=1"
      end

      it 'retrieves the repositories for a user' do 
        stub_request(:get, "https://api.github.com/users/cmeik/repos?access_token=1").
          to_return(:status => 200, :body => repository_response_body, :headers => repository_response_headers)
        stub_request(:get, "https://api.github.com/users/cmeik/repos?access_token=1&page=2").
          to_return(:status => 200, :body => "[]", :headers => {})

        subject.repositories_for_user(user).should == JSON.parse(repository_response_body)
      end

      context 'and a repository' do
        let(:repository) { mock('repository', :[] => 'wine_dot_com_api_request') }

        it 'retrieves the commits for a users repository' do
          stub_request(:get, "https://api.github.com/repos/cmeik/wine_dot_com_api_request/commits?access_token=1").
            to_return(:status => 200, :body => commit_response_body, :headers => {})

          subject.commits_for_user_and_repository(user, repository).should == JSON.parse(commit_response_body)
        end

        it 'can convert the commit list into a count by day hash' do
          commit_by_date = { "2010-01-02" => 1 } 
          subject.commits_to_daily_count(JSON.parse(commit_response_body)).should == commit_by_date
        end
      end
    end
  end
end
