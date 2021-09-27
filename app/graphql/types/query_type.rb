# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # rubocop:disable GraphQL/ExtractType
    field :get_bucket_details, resolver: Queries::BucketQueries::BucketShowQuery
    field :get_buckets_list, resolver: Queries::BucketQueries::BucketListQuery
    field :get_income_category_list, resolver: Queries::IncomeCategoryQueries::IncomeCategoryListQuery
    field :me, resolver: Queries::UserQueries::MeQuery
    # rubocop:enable GraphQL/ExtractType
  end
end
