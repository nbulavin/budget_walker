# frozen_string_literal: true

class CreateExpenseCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :expense_categories do |t|
      t.string :name, null: false
      t.integer :expected_spending
      t.integer :actual_spending, null: false, default: 0
      t.timestamps
    end
  end
end
