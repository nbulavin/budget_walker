# frozen_string_literal: true

module BucketServices
  class SortOrderPreparer
    # @param [User] user
    def initialize(user)
      @user = user
    end

    def call
      existing_order_rank = @user.buckets.maximum(:sort_order)

      return 0 unless existing_order_rank

      existing_order_rank + 1
    end
  end
end
