class CreateWizardQuestions < ActiveRecord::Migration
  def change
    create_table :wizard_questions do |t|
      t.string :text

      t.timestamps null: false
    end
  end
end
