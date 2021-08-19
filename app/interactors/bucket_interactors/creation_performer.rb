# frozen_string_literal: true

module BucketInteractors
  class CreationPerformer
    class InvalidPayloadError < StandardError
    end

    include Interactor

    before do
      context.errors = {}
    end

    def call
      result = prepare_payload
      raise InvalidPayloadError unless result.success?

      context.bucket = create_bucket(result.to_h)
    rescue InvalidPayloadError
      add_error(result.errors.to_h)
    rescue StandardError
      add_error({ common: I18n.t('interactors.bucket_interactors.creation_performer.errors.main_error') })
    end

    private

    def prepare_payload
      BucketContracts::OnCreationContract.new.call(**context.payload)
    end

    def create_bucket(formatted_payload)
      Bucket.create!(formatted_payload)
    end

    def add_error(error_hash)
      context.errors = error_hash
      context.fail!
    end
  end
end
