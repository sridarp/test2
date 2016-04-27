class ThemePolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    user.admin?
  end
end
