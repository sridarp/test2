class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, 'must be logged in' unless user
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  private

  def project_role_permits?(project_id, action)
    user.roles
      .joins(:projects)
      .where('projects.id' => project_id)
      .where('permissions->:model_type ? :permission',
        model_type: table_name(record),
        permission: action)
      .exists?
  end

  def logged_in?
    true
  end

  def manager?
    user.manager? || user.admin?
  end

  def admin?
    user.admin?
  end

  def table_name(object)
    if object.respond_to? :table_name
      object.table_name
    elsif object.class.respond_to? :table_name
      object.class.table_name
    else
      raise ArgumentError, "#{object.inspect} or its singleton class do not define `table_name`."
    end
  end
end
