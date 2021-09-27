# frozen_string_literal: true

module Types
  module Bucket
    class BucketListType < Types::BaseObject
      field :list, [Types::Bucket::BucketObjectType], null: false
      field :total_count, Integer, null: false
    end
  end
end
