module UseCase
  extend ActiveSupport::Concern

  class Error < StandardError
  end

  module ClassMethods
    # The perform method of a UseCase should always return itself
    def perform(*args)
      new(*args).tap(&:perform)
    end
  end

  # implement all the steps required to complete this use case
  def perform
    raise NotImplementedError
  end
end
