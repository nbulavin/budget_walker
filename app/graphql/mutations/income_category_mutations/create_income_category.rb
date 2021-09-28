# frozen_string_literal: true

module Mutations
  module IncomeCategoryMutations
    class CreateIncomeCategory < Mutations::BaseMutation
      null true
      description 'Creates income category'

      argument :expected_revenue, Integer, required: false
      argument :name, String, required: true

      field :errors, GraphQL::Types::JSON, null: true
      field :income_category, Types::IncomeCategory::IncomeCategoryObjectType, null: true

      def resolve(**args)
        raise_unauthorized_error unless authorized_user?

        result = IncomeCategoryInteractors::CreationPerformer.call(payload: prepare_arguments(args))

        {
          errors: formatted_json(result.errors),
          income_category: result.income_category
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
