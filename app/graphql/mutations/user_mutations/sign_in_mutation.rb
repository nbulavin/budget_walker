# frozen_string_literal: true

module Mutations
  module UserMutations
    class SignInMutation < Mutations::BaseMutation
      null true

      argument :email, String, required: true
      argument :password, String, required: true

      field :me, Types::UserType, null: true
      field :errors, [String], null: false
      field :token, String, null: true

      def resolve(email:, password:)
        result = UserInteractors::Authorization::SignInPerformer.call(email: email, password: password)

        {
          errors: result.errors,
          me: result.me,
          token: result.token
        }
      end
    end
  end
end
