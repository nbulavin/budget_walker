# frozen_string_literal: true

module Queries
  module BucketQueries
    class BucketShowQuery < Queries::BaseQuery
      description 'Returns info about bucket available for user'

      argument :id, Integer, required: true

      type Types::Bucket::BucketObjectType, null: true

      def resolve(id:)
        raise_unauthorized_error unless authorized_user?

        current_user.buckets.find(id)
      rescue ActiveRecord::RecordNotFound
        raise GraphQL::ExecutionError, I18n.t('graphql.common.errors.record_not_found')
      end
    end
  end
end
