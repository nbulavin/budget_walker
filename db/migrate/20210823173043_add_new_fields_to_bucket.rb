# frozen_string_literal: true

class AddNewFieldsToBucket < ActiveRecord::Migration[6.1]
  def change
    change_table :buckets, bulk: true do |t|
      t.string :provider
      t.integer :sort_order, default: 0, null: false
      t.integer :current_balance, default: 0, null: false
      t.string :color
      t.string :description
    end
  end
end
