module Gitometer
  module GithubHelpers

    # API endpoint for GitHub.
    #
    def endpoint 
      "https://api.github.com"
    end

    # Returns a query param for a users access token.
    #
    def access_token_param_for_user(user)
      "access_token=#{user.token}"
    end

    # Returns a query param for a page.
    #
    def param_for_page(page)
      "page=#{page}" if page
    end

    # Recursively finds all repositories for a particular github user by
    # page.
    #
    def repositories_for_user(user, page = nil)
      response = RestClient.get "#{endpoint}/users/#{user.login}/repos?#{access_token_param_for_user(user)}&#{param_for_page(page)}"
      body     = JSON.parse(response.body)

      if response.headers[:link] =~ /page=(\d+).*next/
        body + repositories_for_user(user, $1)
      else
        body
      end
    end

    # Find all commits for a particular repository and user.
    #
    def commits_for_user_and_repository(user, repository)
      response = RestClient.get "#{endpoint}/repos/#{user.login}/#{repository['name']}/commits?#{access_token_param_for_user(user)}"
      JSON.parse(response.body)
    end

    # Converts an array of commits to a hash of date to commit counts.
    #
    def commits_to_daily_count(commits) 
      commits = commits.flatten.inject({}) do |h, v|
        key = Time.parse(v["commit"]["author"]["date"]).utc.strftime("%Y-%m-%d")
        h[key] = h[key].nil? ? 1 : h[key] + 1
        h
      end
      commits = Hash[commits.sort]
    end

  end
end
