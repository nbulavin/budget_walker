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
      raise GraphQL::ExecutionError
              .new(
                I18n.t('graphql.common.errors.not_authorized'),
                extensions: {
                  code: :unauthorized
                }
              )
    end

    def formatted_json(errors)
      errors.transform_keys { |key| key.to_s.camelcase(:lower) }
    end
  end
end
