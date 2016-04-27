class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.timestamps

      t.references :staff, index: true

      t.string :provider
      t.string :uid
    end
    add_index :authentications, [:provider, :uid]
  end
end
