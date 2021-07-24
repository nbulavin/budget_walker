# frozen_string_literal: true

module UserServices
  module Authorization
    class SignInPerformer
      # @param [String] email
      # @param [String] password
      def initialize(email:, password:)
        @email = email
        @password = password
        @errors = []
      end

      # @return [Hash]
      # @example
      #   {
      #     me: <User>, # User object
      #     token: 'test',
      #     errors: []
      #   }
      def call
        find_user
        authenticate
        generate_auth_token

        {
          errors: @errors,
          me: @errors.empty? ? @user : nil,
          token: @errors.empty? ? @user.authorization_token : nil
        }
      end

      private

      def find_user
        @user = User.find_by(email: @email)

        add_error unless @user
      end

      def authenticate
        return unless @user

        result = @user.authenticate(@password)
        add_error unless result
      end

      def add_error
        @errors << 'Oops, unable to log in'
      end

      def generate_auth_token
        return unless @errors.empty?
        return if @user.authorization_token

        @user.update!(authorization_token: ::SecureRandom.uuid)
      end
    end
  end
end
