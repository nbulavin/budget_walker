# frozen_string_literal: true

module BucketContracts
  class OnUpdateContract < ApplicationContract
    config.messages.namespace = :bucket_validation

    params do
      required(:user).filled(type?: User)
      required(:id).filled(:integer)
      optional(:name).filled(:string)
      optional(:bucket_type).filled(:symbol, included_in?: Bucket.bucket_types.keys.map(&:to_sym))
      optional(:expected_enrollment).value(:date_time)
    end
  end
end
