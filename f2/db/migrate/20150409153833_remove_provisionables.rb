class RemoveProvisionables < ActiveRecord::Migration
  def change
    remove_columns :products, :provisionable_type, :provisionable_id
    drop_table :manage_iq_products
    drop_table :team_member_products
  end
end
