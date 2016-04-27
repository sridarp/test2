class AddFormSchemaToProductTypes < ActiveRecord::Migration
  def change
    add_column :product_types, :questions_form_schema, :json
  end
end
