# frozen_string_literal: true

module Mutations
  module BucketMutations
    class UpdateMutation < Mutations::BaseMutation
      null true

      argument :id, Integer, required: true
      argument :name, String, required: false
      argument :bucket_type, Types::Bucket::TypeEnum, required: false
      argument :expected_enrollment, Integer, required: false
      argument :provider, String, required: false
      argument :sort_order, Integer, required: false
      argument :color, String, required: false
      argument :description, String, required: false

      field :bucket, Types::Bucket::ObjectType, null: true
      field :errors, GraphQL::Types::JSON, null: true

      def resolve(**args)
        raise_unauthorized_error unless authorized_user?

        result = BucketInteractors::UpdatePerformer.call(payload: prepare_arguments(args))

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
