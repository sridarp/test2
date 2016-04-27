class RegisteredProviderPolicy < ApplicationPolicy
  def index?
    admin?
  end
end
