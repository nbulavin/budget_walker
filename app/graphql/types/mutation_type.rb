# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_income_category, mutation: Mutations::IncomeCategoryMutations::CreateIncomeCategory

    field :create_bucket, mutation: Mutations::BucketMutations::CreateBucket
    field :update_bucket, mutation: Mutations::BucketMutations::UpdateBucket

    field :sign_in, mutation: Mutations::UserMutations::SignIn
  end
end
