# frozen_string_literal: true

module Queries
  module IncomeCategoryQueries
    class IncomeCategoryShowQuery < Queries::BaseQuery
      description 'Returns income category available for user'

      argument :id, Integer, required: true

      type Types::IncomeCategory::IncomeCategoryObjectType, null: true

      def resolve(id:)
        raise_unauthorized_error unless authorized_user?

        current_user.income_categories.find(id)
      rescue ActiveRecord::RecordNotFound
        raise GraphQL::ExecutionError, I18n.t('graphql.common.errors.record_not_found')
      end
    end
  end
end
