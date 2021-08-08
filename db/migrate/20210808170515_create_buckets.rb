# frozen_string_literal: true

class CreateBuckets < ActiveRecord::Migration[6.1]
  def change
    create_table :buckets do |t|
      t.string :name
      t.integer :expected_enrollment
      t.integer :type

      t.timestamps
    end
  end
end
