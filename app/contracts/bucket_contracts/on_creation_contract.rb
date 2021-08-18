# frozen_string_literal: true

module BucketContracts
  class OnCreationContract < ApplicationContract
    config.messages.namespace = :bucket_validation

    params do
      required(:user).filled(type?: User)
      required(:name).filled(:string)
      required(:bucket_type).filled(:symbol, included_in?: Bucket.bucket_types.keys.map(&:to_sym))
      optional(:expected_enrollment).value(:date_time)
    end
  end
end
