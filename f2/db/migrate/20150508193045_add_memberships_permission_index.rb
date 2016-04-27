class AddMembershipsPermissionIndex < ActiveRecord::Migration
  def up
    execute <<-SQL
      DROP INDEX index_roles_on_permissions_affiliations;
      CREATE INDEX index_roles_on_permissions_memberships ON roles USING gin((permissions->'memberships'));
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX index_roles_on_permissions_memberships;
      CREATE INDEX index_roles_on_permissions_affiliations ON roles USING gin((permissions->'affiliations'));
    SQL
  end
end
