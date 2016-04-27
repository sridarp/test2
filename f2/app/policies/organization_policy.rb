class OrganizationPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.admin?
  end

  def show?
    true
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
