# frozen_string_literal: true

class CreateSavings < ActiveRecord::Migration[6.1]
  def change
    create_table :savings do |t|
      t.string :name
      t.references :user, foreign_key: true, index: true
      t.integer :sort_order, default: 0, null: false
      t.timestamps
    end
  end
end
