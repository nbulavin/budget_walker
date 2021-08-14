# frozen_string_literal: true

module Mutations
  module BucketMutations
    class CreateMutation < Mutations::BaseMutation
      null true

      argument :name, String, required: true
      argument :type, Types::Bucket::TypeEnum, required: true
      argument :expected_enrollment, String, required: false

      field :bucket, Types::Bucket::ObjectType, null: true
      field :errors, [String], null: true

      def resolve(name:, type:, expected_enrollment: nil)
        raise_unauthorized_error unless authorized_user?

        result = BucketInteractors::CreationPerformer
                   .call(name: name, type: type, expected_enrollment: expected_enrollment, creator: current_user)

        {
          errors: result.errors,
          bucket: result.bucket
        }
      end
    end
  end
end
