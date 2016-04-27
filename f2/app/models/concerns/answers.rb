module Answers
  extend ActiveSupport::Concern

  included do
    has_many :answers, as: :answerable
  end

  def settings
    @_settings ||= Hash[answers.map { |answer| [answer.name.to_sym, answer.value] }]
  end
end
