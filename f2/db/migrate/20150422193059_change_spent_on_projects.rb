class ChangeSpentOnProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :spent
    add_column :projects, :spent, :float
  end
end
