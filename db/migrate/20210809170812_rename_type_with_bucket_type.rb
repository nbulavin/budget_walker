# frozen_string_literal: true

class RenameTypeWithBucketType < ActiveRecord::Migration[6.1]
  def change
    rename_column :buckets, :type, :bucket_type
  end
end
