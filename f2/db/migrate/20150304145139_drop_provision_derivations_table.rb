class DropProvisionDerivationsTable < ActiveRecord::Migration
  def change
    drop_table :provision_derivations
  end
end
