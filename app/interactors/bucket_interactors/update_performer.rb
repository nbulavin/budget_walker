# frozen_string_literal: true

module BucketInteractors
  class UpdatePerformer < ApplicationInteractor
    class InvalidPayloadError < StandardError
    end

    before do
      context.errors = {}
    end

    def call
      result = prepare_payload
      raise InvalidPayloadError unless result.success?

      bucket = find_bucket(result)
      context.bucket = update_bucket(bucket, result.to_h)
    rescue InvalidPayloadError
      add_error(result.errors.to_h)
    rescue ActiveRecord::RecordNotFound
      add_error({ common: [I18n.t('interactors.bucket_interactors.update_performer.errors.record_not_found')] })
    rescue StandardError
      add_error({ common: [I18n.t('interactors.bucket_interactors.update_performer.errors.main_error')] })
    end

    private

    def prepare_payload
      BucketContracts::OnUpdateContract.new.call(**context.payload)
    end

    def find_bucket(result)
      result[:user].buckets.find(result[:id])
    end

    def update_bucket(bucket, formatted_payload)
      result = bucket.update!(formatted_payload.except(:user))
      return unless result

      bucket
    end

    def attributes_to_update(formatted_payload)
      attributes = {}
      attributes[:name] = formatted_payload[:name] if formatted_payload.key?(:name)
      if formatted_payload.key?(:bucket_type)
        attributes[:bucket_type] = Bucket.bucket_types[formatted_payload[:bucket_type]]
      end
      if formatted_payload.key?(:expected_enrollment)
        attributes[:expected_enrollment] = formatted_payload[:expected_enrollment]
      end
      attributes
    end

    def add_error(error_hash)
      context.errors = error_hash
      context.fail!
    end
  end
end
