module Gitometer
  module GithubHelpers
    def endpoint 
      "https://api.github.com"
    end

    def profile_page_url_for(user)
      "http://github.com/#{user.login}"
    end

    def access_token_param_for_user(user)
      "access_token=#{user.token}"
    end

    def repositories_for_user(user)
      response = RestClient.get "#{endpoint}/users/#{user.login}/repos?#{access_token_param_for_user(user)}"
      JSON.parse(response)
    end

    def commits_for_user_and_repository(user, repository)
      response = RestClient.get "#{endpoint}/repos/#{user.login}/#{repository['name']}/commits?#{access_token_param_for_user(user)}"
      JSON.parse(response)
    end

    def commits_to_daily_count(commits) 
      commits = commits.flatten.inject({}) do |h, v|
        key = Time.parse(v["commit"]["author"]["date"]).strftime("%Y-%m-%d")
        h[key] = h[key].nil? ? 1 : h[key] + 1
        h
      end
      commits = Hash[commits.sort]
    end
  end
end
