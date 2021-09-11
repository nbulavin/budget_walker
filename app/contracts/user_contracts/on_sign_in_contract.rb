# frozen_string_literal: true

module UserContracts
  class OnSignInContract < ApplicationContract
    config.messages.namespace = :user_validation

    params do
      required(:email).filled(:string)
      required(:password).filled(:string)
    end

    rule(:email) do
      key.failure(:incorrect_format) unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
    end

    rule(:password) do
      key.failure(:too_short) if value.length < 4
    end
  end
end
