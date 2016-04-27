class ProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    can?('read')
  end

  def new?
    user.admin? || user.groups.any?
  end

  def destroy?
    can?('write')
  end

  def create?
    user.admin? || user.groups.any?
  end

  def update?
    can?('write')
  end

  # TODO: These should be their own policy/controller
  def approvals?
    true
  end

  def approve?
    user.admin?
  end

  def reject?
    user.admin?
  end

  private

  def can?(action)
    return true if user.admin?
    object = record || Project
    Permissions.new(user: user, object: object).allow?(action)
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope
      else
        user.projects
      end
    end
  end
end
