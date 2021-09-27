# frozen_string_literal: true

module Queries
  module IncomeCategoryQueries
    class IncomeCategoryListQuery < Queries::BaseQuery
      description 'Returns list of income categories available for user'

      type Types::IncomeCategory::IncomeCategoryListType, null: true

      def resolve
        raise_unauthorized_error unless authorized_user?

        categories = current_user.income_categories
        {
          list: categories,
          total_count: categories.count
        }
      end
    end
  end
end
