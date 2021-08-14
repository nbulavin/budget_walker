# frozen_string_literal: true

module Queries
  module UserQueries
    class MeQuery < Queries::BaseQuery
      description 'Returns current user info'

      type Types::UserType, null: true

      def resolve
        context[:current_user]
      end
    end
  end
end
