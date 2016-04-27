class AdjustProductColumns < ActiveRecord::Migration
  class Product < ActiveRecord::Base
  end

  class ManageIqProduct < ActiveRecord::Base
  end

  def up
    add_column :products, :provisionable_type, :string
    add_column :products, :provisionable_id, :integer
    add_index :products, :provisionable_id

    create_table :manage_iq_products do |t|
      t.timestamps
      t.integer :service_type_id
      t.integer :service_catalog_id
      t.string :chef_role, limit: 100
      t.json :options
      t.integer :cloud_id
    end

    create_table :team_member_products do |t|
      t.timestamps
    end

    Product.reset_column_information
    ManageIqProduct.reset_column_information
    Product.all.each do |product|
      manage_iq_product = ManageIqProduct.create(
        service_type_id: product.service_type_id,
        service_catalog_id: product.service_catalog_id,
        chef_role: product.chef_role,
        options: product.options.to_json,
        cloud_id: product.cloud_id
      )

      product.provisionable_id = manage_iq_product.id
      product.provisionable_type = 'ManageIqProduct'
      product.save!
    end

    remove_column :products, :service_type_id
    remove_column :products, :service_catalog_id
    remove_column :products, :cloud_id
    remove_column :products, :chef_role
    remove_column :products, :options
  end

  def down
    drop_table :team_member_products

    add_column :products, :service_type_id, :integer
    add_column :products, :service_catalog_id, :integer
    add_column :products, :cloud_id, :integer
    add_column :products, :chef_role, :string
    add_column :products, :options, :json

    Product.reset_column_information
    ManageIqProduct.reset_column_information
    Product.all.each do |product|
      m_iq_product = ManageIqProduct.find(product.provisionable_id)
      product.service_type_id = m_iq_product.service_type_id
      product.service_catalog_id =  m_iq_product.service_catalog_id
      product.chef_role = m_iq_product.chef_role
      product.options = m_iq_product.options
      product.cloud_id = m_iq_product.cloud_id
      product.save!
    end

    remove_column :products, :provisionable_type
    remove_column :products, :provisionable_id
    drop_table :manage_iq_products
  end
end
