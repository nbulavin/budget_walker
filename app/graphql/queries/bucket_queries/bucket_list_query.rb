# frozen_string_literal: true

module Queries
  module BucketQueries
    class BucketListQuery < Queries::BaseQuery
      description 'Returns list of buckets available for user'

      type Types::Bucket::BucketListType, null: true

      def resolve
        raise_unauthorized_error unless authorized_user?

        buckets = current_user.buckets
        {
          list: buckets,
          total_count: buckets.count
        }
      end
    end
  end
end
