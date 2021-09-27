# frozen_string_literal: true

module Types
  module Bucket
    class BucketObjectType < Types::BaseObject
      field :bucket_type, String, null: false
      field :color, String, null: true
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :current_balance, Integer, null: true
      field :description, String, null: true
      field :expected_enrollment, Integer, null: true
      field :id, Integer, null: false
      field :name, String, null: false
      field :provider, String, null: true
      field :sort_order, Integer, null: true
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :user_id, Integer, null: true
    end
  end
end
