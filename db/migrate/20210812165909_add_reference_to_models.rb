# frozen_string_literal: true

class AddReferenceToModels < ActiveRecord::Migration[6.1]
  def change
    add_reference :expense_categories, :bucket, foreign_key: true, index: true
    add_reference :income_categories, :bucket, foreign_key: true, index: true
  end
end
