class RemoveSettings < ActiveRecord::Migration
  def change
    drop_table :settings
    drop_table :setting_fields
  end
end
