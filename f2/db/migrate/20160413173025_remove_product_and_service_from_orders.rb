class RemoveProductAndServiceFromOrders < ActiveRecord::Migration
  def change
    remove_foreign_key :orders, :products
    remove_foreign_key :orders, :services

    remove_column :orders, :product_id
    remove_column :orders, :service_id
  end
end
