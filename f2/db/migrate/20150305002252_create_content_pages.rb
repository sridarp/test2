class CreateContentPages < ActiveRecord::Migration
  def change
    create_table :content_pages do |t|
      t.timestamps
      t.datetime :deleted_at

      t.references :staff, index: true

      t.string :slug, null: false
      t.string :title, null: false
      t.text :body
    end
    add_index :content_pages, :slug, unique: true
  end
end
