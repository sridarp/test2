class AddAnswersColumnToProducts < ActiveRecord::Migration
  def change
    add_column :products, :provisioning_answers, :json
  end
end
