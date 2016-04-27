class ProductTypePolicy < ApplicationPolicy
  def index?
    logged_in?
  end

  def show?
    logged_in?
  end

  def async_select?
    logged_in?
  end
end
