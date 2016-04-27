class MigrateProductAnswersToJson < ActiveRecord::Migration
  class Product < ActiveRecord::Base
    has_many :product_answers
  end

  class ProductAnswer < ActiveRecord::Base
    belongs_to :product_type_question
  end

  class ProductTypeQuestion < ActiveRecord::Base
  end

  def up
    Product.reset_column_information
    ProductAnswer.reset_column_information
    ProductTypeQuestion.reset_column_information

    Product.all.each do |product|
      answers = {}

      product.product_answers.each do |answer|
        answers[answer.product_type_question.manageiq_key] = answer.answer
      end

      product.provisioning_answers = answers
      product.save!
    end

    drop_table :product_answers
    drop_table :product_type_questions
  end

  def down
    create_table :product_answers do |t|
      t.timestamps
      t.integer :product_id, null: false
      t.integer :product_type_question_id, null: false
      t.text :answer

      t.index :product_id
      t.index :product_type_question_id
    end

    create_table :product_type_questions do |t|
      t.timestamps
      t.integer :product_type_id, null: false
      t.text :label
      t.string :field_type
      t.string :placeholder
      t.text :help
      t.column :options, :json
      t.text :default
      t.boolean :required, default: false
      t.integer :load_order
      t.string :manageiq_key

      t.index [:product_type_id, :load_order], name: 'question_order_idx'
    end
  end
end
