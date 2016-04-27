class RenameServiceAttributes < ActiveRecord::Migration
  def change
    rename_table :service_attributes, :service_outputs
  end
end
