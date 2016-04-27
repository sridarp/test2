class AlterOrderItemsTable < ActiveRecord::Migration
  def change
    remove_column :order_items, :password
    rename_column :order_items, :payload_to_miq, :payload_request
    rename_column :order_items, :payload_reply_from_miq, :payload_acknowledgement
    rename_column :order_items, :payload_response_from_miq, :payload_response
    change_column :order_items, :payload_request, :json
    change_column :order_items, :payload_acknowledgement, :json
    change_column :order_items, :payload_response, :json
  end
end
