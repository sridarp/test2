class MigrateJsonToJsonb < ActiveRecord::Migration
  def up
    change_column :order_items, :payload_request, 'jsonb USING CAST(payload_request AS jsonb)'
    change_column :order_items, :payload_acknowledgement, 'jsonb USING CAST(payload_acknowledgement AS jsonb)'
    change_column :order_items, :payload_response, 'jsonb USING CAST(payload_response AS jsonb)'
    change_column :orders, :options, 'jsonb USING CAST(options AS jsonb)'
    change_column :products, :provisioning_answers, 'jsonb USING CAST(provisioning_answers AS jsonb)'
    change_column :project_questions, :options, 'jsonb USING CAST(options AS jsonb)'
  end

  def down
    change_column :order_items, :payload_request, 'json USING CAST(payload_request AS json)'
    change_column :order_items, :payload_acknowledgement, 'json USING CAST(payload_acknowledgement AS json)'
    change_column :order_items, :payload_response, 'json USING CAST(payload_response AS json)'
    change_column :orders, :options, 'json USING CAST(options AS json)'
    change_column :products, :provisioning_answers, 'json USING CAST(provisioning_answers AS json)'
    change_column :project_questions, :options, 'json USING CAST(options AS json)'
  end
end
