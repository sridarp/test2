class AddTypeToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :category, :string
  end
end
