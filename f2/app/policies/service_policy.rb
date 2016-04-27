class ServicePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    admin_or_related
  end

  def all_count?
    true
  end

  def operations?
    true
  end

  def project_count?
    true
  end

  def count?
    true
  end

  def order_profiles?
    true
  end

  def admin_or_related
    user.admin? || user.project_ids.include?(record.project_id)
  end

  class Scope < Scope
    def resolve
      projects = if user.admin?
                   Project.all
                 else
                   # Users are only allowed to see services from projects they are staff on
                   Project.joins(:staff_projects).where(staff_projects: { staff_id: user.id })
                 end
      services = []
      projects.each do |project|
        OrderItem.where(project_id: project.id).each do |order_item|
          services << order_item
        end
      end
      services
    end
  end
end
