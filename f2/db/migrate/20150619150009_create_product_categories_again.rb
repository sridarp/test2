class CreateProductCategoriesAgain < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.string :name
      t.string :description
      t.string :img
      t.string :cached_tag_list
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end
