class Service < ActiveRecord::Base
  class Compute < Service
    def actions
      [:start, :stop]
    end
  end
end
