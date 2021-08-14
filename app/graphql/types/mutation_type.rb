# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :sign_in, mutation: Mutations::UserMutations::SignInMutation
    field :create_bucket, mutation: Mutations::BucketMutations::CreateMutation
  end
end
