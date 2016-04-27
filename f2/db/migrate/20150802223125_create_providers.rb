class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.timestamps null: false
      t.timestamp :deleted_at
      t.string :type, null: false, index: true
      t.references :registered_provider, null: false, index: true
      t.string :name, null: false
      t.text :description
      t.boolean :active
      t.string :cached_tag_list
    end
  end
end
