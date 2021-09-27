# frozen_string_literal: true

module Mutations
  module BucketMutations
    class CreateMutation < Mutations::BaseMutation
      null true

      argument :bucket_type, Types::Bucket::TypeEnum, required: true
      argument :color, String, required: false
      argument :description, String, required: false
      argument :expected_enrollment, Integer, required: false
      argument :name, String, required: true
      argument :provider, String, required: false
      argument :sort_order, Integer, required: false

      field :bucket, Types::Bucket::BucketObjectType, null: true
      field :errors, GraphQL::Types::JSON, null: true

      def resolve(**args)
        raise_unauthorized_error unless authorized_user?

        result = BucketInteractors::CreationPerformer.call(payload: prepare_arguments(args))

        {
          errors: formatted_json(result.errors),
          bucket: result.bucket
        }
      end

      private

      def prepare_arguments(args)
        args[:user] = current_user
        args
      end
    end
  end
end
