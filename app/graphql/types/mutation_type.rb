# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_bucket, mutation: Mutations::BucketMutations::CreateMutation
    field :sign_in, mutation: Mutations::UserMutations::SignInMutation
    field :update_bucket, mutation: Mutations::BucketMutations::UpdateMutation
  end
end
