class RenameLoadOrderProjectQuestions < ActiveRecord::Migration
  def change
    rename_column :project_questions, :load_order, :position
  end
end
