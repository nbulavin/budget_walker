# frozen_string_literal: true

module Queries
  module BucketQueries
    class ListQuery < Queries::BaseQuery
      description 'Returns list of buckets available for user'

      type Types::Bucket::ListType, null: true

      def resolve
        raise_unauthorized_error unless authorized_user?

        {
          list: current_user.buckets,
          total_count: current_user.buckets.count
        }
      end
    end
  end
end
