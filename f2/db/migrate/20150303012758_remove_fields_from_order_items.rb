class RemoveFieldsFromOrderItems < ActiveRecord::Migration
  def change
    remove_column :order_items, :host
    remove_column :order_items, :port
    remove_column :order_items, :public_ip
    remove_column :order_items, :hostname
    remove_column :order_items, :url
    remove_column :order_items, :instance_name
    remove_column :order_items, :instance_id
    remove_column :order_items, :username
    remove_column :order_items, :password
    remove_column :order_items, :status_msg
    remove_column :order_items, :private_ip
  end
end
