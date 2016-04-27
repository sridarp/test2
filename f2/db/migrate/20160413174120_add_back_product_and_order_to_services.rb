class AddBackProductAndOrderToServices < ActiveRecord::Migration
  def change
    add_column :services, :product_id, :integer
    add_column :services, :order_id, :integer
  end
end
