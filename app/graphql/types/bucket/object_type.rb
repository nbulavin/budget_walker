# frozen_string_literal: true

module Types
  module Bucket
    class ObjectType < Types::BaseObject
      field :id, Integer, null: false
      field :name, String, null: false
      field :expected_enrollment, Integer, null: true
      field :bucket_type, String, null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :user_id, Integer, null: true
    end
  end
end
