# frozen_string_literal: true

module Queries
  module BucketQueries
    class ListQuery < Queries::BaseQuery
      description 'Returns list of buckets available for user'

      type Types::BucketsListType, null: true

      def resolve
        current_user = context[:current_user]

        raise GraphQL::ExecutionError, I18n.t('graphql.common.errors.not_authorized') unless current_user

        {
          list: current_user.buckets,
          total_count: current_user.buckets.count
        }
      end
    end
  end
end
