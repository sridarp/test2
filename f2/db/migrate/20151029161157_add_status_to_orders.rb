class AddStatusToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :status, :integer, default: 0
    add_column :orders, :status_msg, :string
  end
end
