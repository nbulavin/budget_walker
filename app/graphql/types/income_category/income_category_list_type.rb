# frozen_string_literal: true

module Types
  module IncomeCategory
    class IncomeCategoryListType < Types::BaseObject
      field :list, [Types::IncomeCategory::IncomeCategoryObjectType], null: false
      field :total_count, Integer, null: false
    end
  end
end
