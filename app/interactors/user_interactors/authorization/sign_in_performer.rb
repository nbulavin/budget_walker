# frozen_string_literal: true

module UserInteractors
  module Authorization
    class SignInPerformer
      class InvalidPayloadError < StandardError
      end

      class NotAuthorizedError < StandardError
      end

      include Interactor

      before do
        context.errors = {}
      end

      def call
        result = prepare_payload
        raise InvalidPayloadError unless result.success?

        user = find_and_authenticate_user(result.to_h)
        raise NotAuthorizedError unless user

        prepare_response(user)
      rescue InvalidPayloadError
        add_error(result.errors.to_h)
      rescue NotAuthorizedError
        add_error({ common: [error_text] })
      end

      private

      def prepare_payload
        UserContracts::OnSignInContract.new.call(**context.payload)
      end

      def find_and_authenticate_user(formatted_payload)
        User.find_by(email: formatted_payload[:email])&.authenticate(formatted_payload[:password])
      end

      def prepare_response(user)
        context.me = user
        generate_auth_token(user)
        context.token = user.authorization_token
      end

      def generate_auth_token(user)
        return unless context.errors.empty?
        return if user.authorization_token

        user.update!(authorization_token: ::SecureRandom.uuid)
      end

      def add_error(error_hash)
        context.errors = error_hash
        context.fail!
      end

      def error_text
        I18n.t('interactors.user_interactors.authorization.sign_in_performer.errors.main_error')
      end
    end
  end
end
