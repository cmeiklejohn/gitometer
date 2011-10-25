shared_context 'a github user' do 
  let(:user) { mock('user', :token => 1, :login => 'cmeik') }
end

shared_context 'a github repository' do 
  let(:repository) { mock('repository', :[] => 'wine_dot_com_api_request') }
end

shared_context 'a valid github repository response' do 
  before do
    stub_request(:get, "https://api.github.com/users/cmeik/repos?access_token=1").
      to_return(:status => 200, :body => repository_response_body, :headers => repository_response_headers)
    stub_request(:get, "https://api.github.com/users/cmeik/repos?access_token=1&page=2").
      to_return(:status => 200, :body => "[]", :headers => {})
  end

  let(:repository_response_body) do 
    '[{"homepage":"http://rubygems.org/gems/wine_dot_com_api_request","html_url":"https://github.com/cmeiklejohn/wine_dot_com_api_request","forks":3,"language":"Ruby","svn_url":"https://svn.github.com/cmeiklejohn/wine_dot_com_api_request","watchers":3,"url":"https://api.github.com/repos/cmeiklejohn/wine_dot_com_api_request","fork":false,"updated_at":"2011-10-04T01:03:25Z","private":false,"size":240,"master_branch":null,"git_url":"git://github.com/cmeiklejohn/wine_dot_com_api_request.git","clone_url":"https://github.com/cmeiklejohn/wine_dot_com_api_request.git","description":"Provides a simple interface to cut down on code duplication when querying the wine.com API. ","owner":{"login":"cmeiklejohn","url":"https://api.github.com/users/cmeiklejohn","avatar_url":"https://secure.gravatar.com/avatar/3e09fee7b359be847ed5fa48f524a3d3?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png","gravatar_id":"3e09fee7b359be847ed5fa48f524a3d3","id":44939},"name":"wine_dot_com_api_request","pushed_at":"2010-01-02T06:46:01Z","id":455669,"ssh_url":"git@github.com:cmeiklejohn/wine_dot_com_api_request.git","open_issues":0,"created_at":"2010-01-02T03:00:05Z"}]'
  end

  let(:repository_response_headers) do 
    {:server=>"nginx/1.0.4", :date=>"Tue, 25 Oct 2011 03:31:29 GMT", :content_type=>"application/json; charset=utf-8", :transfer_encoding=>"chunked", :connection=>"keep-alive", :status=>"200 OK", :x_ratelimit_limit=>"5000", :etag=>"\"XXX\"", :x_oauth_scopes=>"", :link=>"<https://api.github.com/users/cmeiklejohn/repos?access_token=XXX&page=2>; rel=\"next\", <https://api.github.com/users/cmeiklejohn/repos?access_token=XXX&page=2>; rel=\"last\"", :x_ratelimit_remaining=>"4534", :x_accepted_oauth_scopes=>"repo" }
  end
end

shared_context 'a valid github commit response' do 
  before do
    stub_request(:get, "https://api.github.com/repos/cmeik/wine_dot_com_api_request/commits?access_token=1").
      to_return(:status => 200, :body => commit_response_body, :headers => {})
  end

  let(:commit_response_body) do 
    '[{"author":null,"sha":"9bda8fef01d6d44fe5997ed258584c616f14c89f","url":"https://api.github.com/repos/cmeiklejohn/wine_dot_com_api_request/commits/9bda8fef01d6d44fe5997ed258584c616f14c89f","parents":[{"sha":"907b8cf9315419d48af720d6989c4c4de9380c00","url":"https://api.github.com/repos/cmeiklejohn/wine_dot_com_api_request/commits/907b8cf9315419d48af720d6989c4c4de9380c00"}],"commit":{"tree":{"sha":"ff84944df9f826ae8d069a183a4e157cb62abccb","url":"https://api.github.com/repos/cmeiklejohn/wine_dot_com_api_request/git/trees/ff84944df9f826ae8d069a183a4e157cb62abccb"},"author":{"email":"cmeik@mac.com","date":"2010-01-01T22:45:39-08:00","name":"Christopher Meiklejohn"},"message":"Added text to readme.","url":"https://api.github.com/repos/cmeiklejohn/wine_dot_com_api_request/git/commits/9bda8fef01d6d44fe5997ed258584c616f14c89f","committer":{"email":"cmeik@mac.com","date":"2010-01-01T22:45:39-08:00","name":"Christopher Meiklejohn"}},"committer":null}]'
  end
end
