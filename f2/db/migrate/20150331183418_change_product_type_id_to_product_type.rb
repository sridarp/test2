class ChangeProductTypeIdToProductType < ActiveRecord::Migration
  def change
    remove_column :products, :product_type_id
    add_column :products, :product_type, :string
  end
end
