class AlertPolicy < ApplicationPolicy
  # TODO: MAKE THIS POLICY REFLECT THE DIFFERENT WAYS AN ALERT CAN BE ASSOCIATED WITH OTHER ENTITIES IN THE SYSTEM
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        # TODO: MAKE ALERTS A USER CREATED AND ALERTS ASSIGNED TO A USER TWO SCOPES?
        user.alerts
      end
    end
  end
end
