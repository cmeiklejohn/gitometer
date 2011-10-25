module Gitometer
  module GithubHelpers
    def endpoint 
      "https://api.github.com"
    end

    def access_token_param_for_user(user)
      "access_token=#{user.token}"
    end

    def param_for_page(page)
      "page=#{page}" if page
    end

    def repositories_for_user(user, page = nil)
      response = RestClient.get "#{endpoint}/users/#{user.login}/repos?#{access_token_param_for_user(user)}&#{param_for_page(page)}"
      body     = JSON.parse(response.body)

      if response.headers[:link] =~ /page=(\d+).*next/
        body + repositories_for_user(user, $1)
      else
        body
      end
    end

    def commits_for_user_and_repository(user, repository)
      response = RestClient.get "#{endpoint}/repos/#{user.login}/#{repository['name']}/commits?#{access_token_param_for_user(user)}"
      JSON.parse(response.body)
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
