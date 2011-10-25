require 'spec_helper'

module Gitometer
  class GithubHelped; include GithubHelpers; end

  describe GithubHelpers do 
    subject { GithubHelped.new } 

    it 'returns the proper endpoint' do 
      subject.endpoint.should == 'https://api.github.com'
    end

    context 'with a user' do 
      include_context 'a github user'
      include_context 'a github repository'
      include_context 'a valid github repository response'
      include_context 'a valid github commit response'

      it 'can parameterize the access token' do 
        subject.access_token_param_for_user(user).should == "access_token=1"
      end

      it 'can paramterize the page' do 
        subject.param_for_page(1).should == "page=1"
      end

      it 'retrieves the repositories for a user' do 
        subject.repositories_for_user(user).should == JSON.parse(repository_response_body)
      end

      context 'and a repository' do
        it 'retrieves the commits for a users repository' do
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
