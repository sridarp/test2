class ChangeProjectFloats < ActiveRecord::Migration
  def change
    remove_column :projects, :spent
    remove_column :projects, :budget
    add_column :projects, :spent, :decimal, precision: 12, scale: 2, default: 0.0
    add_column :projects, :budget, :decimal, precision: 12, scale: 2, default: 0.0
  end
end
