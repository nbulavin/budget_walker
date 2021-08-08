# frozen_string_literal: true

class AddUserReferencesToModels < ActiveRecord::Migration[6.1]
  def change
    add_reference :buckets, :user, index: true, foreign_key: true
    add_reference :expense_categories, :user, index: true, foreign_key: true
  end
end
