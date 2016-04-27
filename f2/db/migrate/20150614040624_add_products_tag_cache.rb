class AddProductsTagCache < ActiveRecord::Migration
  class Product < ActiveRecord::Base
    acts_as_taggable
  end

  def up
    add_column :products, :cached_tag_list, :string
    Product.reset_column_information
    ActsAsTaggableOn::Taggable::Cache.included(Product)
    Product.find_each(:batch_size => 1000) do |p|
      p.tag_list
      p.save!
    end
  end

  def down
    remove_column :products, :cached_tag_list
  end
end
