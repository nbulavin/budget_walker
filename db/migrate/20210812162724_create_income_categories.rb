# frozen_string_literal: true

class CreateIncomeCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :income_categories do |t|
      t.references :user, foreign_key: true, index: true
      t.string :name
      t.integer :expected_revenue
      t.timestamps
    end
  end
end
