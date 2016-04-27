class CreateApiTokens < ActiveRecord::Migration
  def change
    create_table :api_tokens do |t|
      t.references :staff, index: true, foreign_key: true
      t.string :token

      t.timestamps null: false
    end
  end
end
