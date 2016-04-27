class UpdateProjectStartEndDates < ActiveRecord::Migration
  def change
    remove_column :projects, :start_date
    remove_column :projects, :end_date
    add_column :projects, :start_date, :timestamp
    add_column :projects, :end_date, :timestamp
  end
end
