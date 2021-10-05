# frozen_string_literal: true

class AddActualRevenueToIncomeCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :income_categories, :actual_revenue, :integer
  end
end
