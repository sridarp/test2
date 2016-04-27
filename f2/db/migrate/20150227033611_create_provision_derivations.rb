class CreateProvisionDerivations < ActiveRecord::Migration
  def change
    create_table :provision_derivations do |t|
      t.references :order_item, index: true
      t.text :name
      t.text :value

      t.timestamps
    end
    add_index :provision_derivations, :id
  end
end
