module Gitometer
  module WardenHelpers
    def ensure_authenticated
      unless env['warden'].authenticate!
        throw(:warden)
      end
    end

    def authenticated?
      env['warden'].authenticated?
    end

    def logout!
      env['warden'].logout
    end

    def user
      env['warden'].user
    end
  end
end
