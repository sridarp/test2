class AddPolyInterfaceToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :alertable_id, :integer
    add_column :alerts, :alertable_type, :string
    add_index :alerts, :alertable_id
  end
end
