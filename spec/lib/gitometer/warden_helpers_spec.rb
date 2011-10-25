require 'spec_helper'

module Gitometer
  class WardenHelped; include WardenHelpers; end

  describe WardenHelpers do 
    subject { WardenHelped.new }
   
    pending 'returns the warden user' 

    pending 'can logout the warden user'

    pending 'can return the authenticated status for a warden user'

    pending 'can ensure the user is authenticated through warden'
  end
end
