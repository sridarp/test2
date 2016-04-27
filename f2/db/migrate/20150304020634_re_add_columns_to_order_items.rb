class ReAddColumnsToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :password, :string
    add_column :order_items, :status_msg, :string
  end
end
