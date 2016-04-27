class CreateWizardAnswers < ActiveRecord::Migration
  def change
    create_table :wizard_answers do |t|
      t.references :wizard_question, index: true
      t.string :text
      t.string :tags_to_add, array: true, default: []
      t.string :tags_to_remove, array: true, default: []

      t.timestamps null: false
    end

    add_foreign_key :wizard_answers, :wizard_questions, on_delete: :cascade
  end
end
