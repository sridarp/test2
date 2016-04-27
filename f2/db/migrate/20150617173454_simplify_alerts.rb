class SimplifyAlerts < ActiveRecord::Migration
  def change
    remove_column :alerts, :order_item_id
    remove_column :alerts, :project_id
    remove_column :alerts, :staff_id
  end
end
