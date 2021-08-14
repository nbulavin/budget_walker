# frozen_string_literal: true

module Types
  module Bucket
    class ListType < Types::BaseObject
      field :list, [Types::Bucket::ObjectType], null: false
      field :total_count, Integer, null: false
    end
  end
end
