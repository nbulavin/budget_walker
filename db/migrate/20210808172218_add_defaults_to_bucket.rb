# frozen_string_literal: true

class AddDefaultsToBucket < ActiveRecord::Migration[6.1]
  def change
    change_column_default :buckets, :type, from: nil, to: 0
    change_column_null :buckets, :type, false
    change_column_null :buckets, :name, false
  end
end
