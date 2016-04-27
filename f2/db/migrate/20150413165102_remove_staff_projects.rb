class RemoveStaffProjects < ActiveRecord::Migration
  def change
    drop_table :staff_projects
  end
end
