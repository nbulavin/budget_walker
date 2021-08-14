# frozen_string_literal: true

module Queries
  module BucketQueries
    class ShowQuery < Queries::BaseQuery
      description 'Returns info about bucket available for user'

      argument :id, Integer, required: true

      type Types::BucketType, null: true

      def resolve(id:)
        current_user = context[:current_user]

        raise GraphQL::ExecutionError, I18n.t('graphql.common.errors.not_authorized') unless current_user

        current_user.buckets.find(id)
      rescue ActiveRecord::RecordNotFound
        raise GraphQL::ExecutionError, I18n.t('graphql.common.errors.record_not_found')
      end
    end
  end
end
