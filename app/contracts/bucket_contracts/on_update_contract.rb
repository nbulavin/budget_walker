# frozen_string_literal: true

module BucketContracts
  class OnUpdateContract < ApplicationContract
    config.messages.namespace = :bucket_validation

    params do
      required(:user).filled(type?: User)
      required(:id).filled(:integer)
      optional(:name).filled(:string)
      optional(:bucket_type).filled(:symbol, included_in?: Bucket.bucket_types.keys.map(&:to_sym))
      optional(:expected_enrollment).maybe(:date_time)
      optional(:provider).maybe(:string)
      optional(:color).maybe(:string)
      optional(:description).maybe(:string)
    end
  end
end
