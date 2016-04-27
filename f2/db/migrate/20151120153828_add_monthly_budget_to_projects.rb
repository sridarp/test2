class AddMonthlyBudgetToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :monthly_budget, :decimal, precision: 12, scale: 2, default: 0.0
  end
end
