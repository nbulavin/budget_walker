# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :me, resolver: Queries::UserQueries::MeQuery
    field :get_buckets_list, resolver: Queries::BucketQueries::ListQuery
    field :get_bucket_details, resolver: Queries::BucketQueries::ShowQuery
  end
end
