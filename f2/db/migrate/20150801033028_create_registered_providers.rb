class CreateRegisteredProviders < ActiveRecord::Migration
  def change
    create_table :registered_providers do |t|
      t.timestamps null: false
      t.timestamp :deleted_at
      t.string :type, null: false, index: true
      t.string :name, null: false
      t.string :uuid, null: false, index: true
    end
  end
end
