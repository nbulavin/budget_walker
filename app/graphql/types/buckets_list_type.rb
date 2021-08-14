# frozen_string_literal: true

module Types
  class BucketsListType < Types::BaseObject
    field :list, [Types::BucketType], null: false
    field :total_count, Integer, null: false
  end
end
