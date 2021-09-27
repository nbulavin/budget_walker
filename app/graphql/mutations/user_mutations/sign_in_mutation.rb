# frozen_string_literal: true

module Mutations
  module UserMutations
    class SignInMutation < Mutations::BaseMutation
      null true

      argument :email, String, required: true
      argument :password, String, required: true

      field :errors, GraphQL::Types::JSON, null: true
      field :me, Types::UserType, null: true
      field :token, String, null: true

      def resolve(**args)
        result = UserInteractors::Authorization::SignInPerformer.call(payload: args)

        {
          errors: formatted_json(result.errors),
          me: result.me,
          token: result.token
        }
      end
    end
  end
end
