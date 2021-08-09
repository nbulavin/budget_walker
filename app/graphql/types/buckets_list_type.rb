# frozen_string_literal: true

module Types
  class BucketsListType < Types::BaseObject
    field :list, [Types::BucketType], null: false
    field :count, Integer, null: false
  end
end
