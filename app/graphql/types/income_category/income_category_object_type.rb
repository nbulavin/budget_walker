# frozen_string_literal: true

module Types
  module IncomeCategory
    class IncomeCategoryObjectType < Types::BaseObject
      field :id, Integer, null: false
      field :user_id, Integer, null: true
      field :name, String, null: true
      field :expected_revenue, Integer, null: true
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
end
