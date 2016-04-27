class CreateMotds < ActiveRecord::Migration
  def change
    create_table :motds do |t|
      t.timestamps
      t.timestamp :deleted_at

      t.references :staff, index: true

      t.integer :staff_id
      t.text :message
    end
  end
end
