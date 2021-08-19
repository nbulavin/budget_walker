# frozen_string_literal: true

module Mutations
  module BucketMutations
    class UpdateMutation < Mutations::BaseMutation
      null true

      argument :id, Integer, required: true
      argument :name, String, required: false
      argument :bucket_type, Types::Bucket::TypeEnum, required: false
      argument :expected_enrollment, String, required: false

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
        arguments = {}
        arguments[:id] = args[:id] if args.key?(:id)
        arguments[:name] = args[:name] if args.key?(:name)
        arguments[:bucket_type] = args[:bucket_type] if args.key?(:bucket_type)
        arguments[:expected_enrollment] = args[:expected_enrollment] if args.key?(:expected_enrollment)
        arguments[:user] = current_user
        arguments
      end
    end
  end
end