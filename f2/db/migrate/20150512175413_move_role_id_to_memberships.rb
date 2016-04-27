class MoveRoleIdToMemberships < ActiveRecord::Migration
  def change
    remove_column :groups, :role_id, :integer, index: true
    add_column :memberships, :role_id, :integer, index: true
  end
end
