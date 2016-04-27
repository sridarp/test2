class RemoveLatestAlertFromOrderItem < ActiveRecord::Migration
  def change
    remove_column :order_items, :latest_alert_id
  end
end
