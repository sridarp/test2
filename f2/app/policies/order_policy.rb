class OrderPolicy < ApplicationPolicy
  def index?
    logged_in?
  end

  def show?
    logged_in?
  end

  def create?
    logged_in?
  end
end
