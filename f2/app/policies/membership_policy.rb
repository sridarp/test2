class MembershipPolicy < ProjectPolicy
  def index?
    admin? || project_role_permits?(record.project_id, :read)
  end

  def show?
    admin? || project_role_permits?(record.project_id, :read)
  end

  def create?
    admin? || project_role_permits?(record.project_id, :write)
  end

  def update?
    admin? || project_role_permits?(record.project_id, :write)
  end

  def destroy?
    admin? || project_role_permits?(record.project_id, :write)
  end
end
