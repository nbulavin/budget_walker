# frozen_string_literal: true

module UserInteractors
  module Authorization
    class SignInPerformer
      include Interactor

      before do
        context.errors = []
      end

      def call
        user = find_and_authenticate_user

        if user
          context.me = user
          generate_auth_token(user)
          context.token = user.authorization_token
        else
          context.fail!(errors: ['Oops, unable to log in']) unless user
        end
      end

      private

      def find_and_authenticate_user
        User.find_by(email: context.email)&.authenticate(context.password)
      end

      def generate_auth_token(user)
        return unless context.errors.empty?
        return if user.authorization_token

        user.update!(authorization_token: ::SecureRandom.uuid)
      end
    end
  end
end
