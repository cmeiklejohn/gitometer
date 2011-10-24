module Gitometer
  module GithubHelpers
    def profile_page_url_for(user)
      "http://github.com/#{user.login}"
    end

    def repositories_for_user(user)
      response = RestClient.get "https://api.github.com/users/#{user.login}/repos?access_token=#{user.token}"
      JSON.parse(response)
    end
  end
end
