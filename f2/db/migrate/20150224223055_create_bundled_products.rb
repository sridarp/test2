class CreateBundledProducts < ActiveRecord::Migration
  def change
    create_table :bundled_products do |t|
      t.references :bundle, index: true
      t.references :product, index: true

      t.timestamps
    end
  end
end
