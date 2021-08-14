# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    null false

    private

    def current_user
      @current_user ||= context[:current_user]
    end

    def authorized_user?
      current_user.present?
    end

    def raise_unauthorized_error
      raise GraphQL::ExecutionError, I18n.t('graphql.common.errors.not_authorized')
    end
  end
end
