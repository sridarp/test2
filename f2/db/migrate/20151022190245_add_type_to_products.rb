class AddTypeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :type, :string, default: 'Product', null: false
  end
end
