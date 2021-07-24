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
        UserServices::Authorization::SignInPerformer.new(email: email, password: password).call
      end
    end
  end
end
