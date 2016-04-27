class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.timestamps null: false

      t.integer :log_level
      t.text :message
      t.string :loggable_type
      t.integer :loggable_id
    end
  end
end
