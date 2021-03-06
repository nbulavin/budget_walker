# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :authorization_token, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :email, String, null: false
    field :first_name, String, null: false
    field :id, ID, null: false
    field :last_name, String, null: true
    field :password_digest, String, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
