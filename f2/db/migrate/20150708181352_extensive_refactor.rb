class ExtensiveRefactor < ActiveRecord::Migration
  class OrderItem < ActiveRecord::Base
    # Relationships
    belongs_to :order
    belongs_to :product
    belongs_to :cloud
    belongs_to :project

    # Columns
    enum provision_status: { ok: 0, warning: 1, critical: 2, unknown: 3, pending: 4, retired: 5 }
  end

  def up
    add_column :projects, :health, :integer, index: true
    add_column :projects, :monthly_spend, :decimal, precision: 12, scale: 2, default: 0.0
    Project.reset_column_information
    Project.find_each do |project|
      project.health = project.status
      project.status = project.approval
      project.save
    end
    remove_column :projects, :approval, :integer
    remove_column :projects, :cc
    remove_column :projects, :staff_id
    Project.reset_column_information

    # Create settings : Storage of unique application-wide settings
    create_table :settings do |t|
      t.timestamps null: false
      t.string :type, index: true, null: false
      t.string :name, unique: true, null: false
      t.text :description
      t.text :value
      t.integer :value_type, default: 0
      t.text :default
    end

    # Add counter_cache columns
    add_column :groups, :staff_count, :integer, default: 0

    # Create answers : Collection of answers for objects
    create_table :answers do |t|
      t.timestamps null: false
      t.references :answerable, null: false, polymorphic: true
      t.string :name, null: false
      t.text :value
      t.integer :value_type

      t.index [:answerable_type, :answerable_id]
    end

    drop_table :product_types

    # Create product_types : 'Products' provided by providers
    create_table :product_types do |t|
      t.timestamps null: false
      t.string :type, index: true, null: false
      t.string :name, null: false
      t.string :uuid, index: true, null: false
      t.boolean :active, default: true, null: false
      t.string :provider_type, index: true, null: false
    end

    # TODO: Migrate products.provisioning_answers to answers
    remove_column :products, :provisioning_answers, :jsonb
    remove_column :products, :product_type
    Product.reset_column_information
    change_column_null :products, :name, false
    change_column_default :products, :active, true
    add_reference :products, :provider, index: true
    add_reference :products, :product_type, index: true

    # Create services : Instances of a product
    create_table :services do |t|
      t.timestamps null: false
      t.string :type, index: true, null: false
      t.string :uuid, index: true, null: false
      t.string :name, null: false
      t.integer :health, default: 0, null: false
      t.integer :status
      t.string :status_msg
    end

    # Create properties : Collection of facts for product_instances
    create_table :service_attributes do |t|
      t.timestamps null: false
      t.references :service, index: true, null: false
      t.string :name, null: false
      t.text :value
      t.integer :value_type
    end

    #
    #
    # TODO: Migrate data from all the following tables into the new ones
    #
    # orders & order_items into services & service_orders
    # products into product_listings
    #
    #

    drop_table :orders
    drop_table :order_items

    # Create orders : Used to record budget utilization
    create_table :orders do |t|
      t.timestamps null: false
      t.references :staff, index: true, null: false, foreign_key: { on_delete: :cascade }
      t.references :project, index: true, null: false, foreign_key: { on_delete: :cascade }
      t.references :product, index: true, null: false, foreign_key: { on_delete: :cascade }
      t.references :service, index: true, unique: true, null: false, foreign_key: { on_delete: :cascade }
      t.decimal :setup_price, precision: 10, scale: 4
      t.decimal :hourly_price, precision: 10, scale: 4
      t.decimal :monthly_price, precision: 10, scale: 4
    end

    #
    # Update project_questions
    #
    add_column :project_questions, :uuid, :string
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
