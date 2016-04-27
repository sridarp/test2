class CreateRolesForGroups < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.text :description
      t.jsonb :permissions
    end

    execute <<-SQL
      CREATE INDEX index_roles_on_permissions_affiliations ON roles USING gin((permissions->'affiliations'));
      CREATE INDEX index_roles_on_permissions_approvals ON roles USING gin((permissions->'approvals'));
      CREATE INDEX index_roles_on_permissions_projects ON roles USING gin((permissions->'projects'));
    SQL

    add_column :groups, :role_id, :integer, index: true
  end
end
