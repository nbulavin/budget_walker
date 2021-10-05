# frozen_string_literal: true

module Types
  module IncomeCategory
    class IncomeCategoryObjectType < Types::BaseObject
      field :actual_revenue, Integer, null: true
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :expected_revenue, Integer, null: true
      field :id, Integer, null: false
      field :name, String, null: true
      field :revenue_percent, Integer, null: true
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
      field :user_id, Integer, null: true

      def revenue_percent
        expected_revenue = object.expected_revenue
        return unless expected_revenue

        actual_revenue = object.actual_revenue
        return 0 unless actual_revenue

        percent = (actual_revenue.to_f / expected_revenue * 100).to_i
        return 100 if percent > 100

        percent
      end
    end
  end
end
