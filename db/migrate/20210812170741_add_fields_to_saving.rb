# frozen_string_literal: true

class AddFieldsToSaving < ActiveRecord::Migration[6.1]
  def change
    add_column :savings, :goal, :integer
    add_column :savings, :expected_enrollment, :integer
  end
end
