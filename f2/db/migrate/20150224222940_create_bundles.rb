class CreateBundles < ActiveRecord::Migration
  def change
    create_table :bundles do |t|
      t.string :name
      t.text :description
      t.string :img
      t.timestamp :active_at
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end
