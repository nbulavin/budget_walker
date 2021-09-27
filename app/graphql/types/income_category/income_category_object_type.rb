# frozen_string_literal: true

module Types
  module IncomeCategory
    class IncomeCategoryObjectType < Types::BaseObject
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :expected_revenue, Integer, null: true
      field :id, Integer, null: false
      field :name, String, null: true
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :user_id, Integer, null: true
    end
  end
end
