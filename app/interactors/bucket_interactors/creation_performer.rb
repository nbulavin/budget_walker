# frozen_string_literal: true

module BucketInteractors
  class CreationPerformer
    include Interactor

    before do
      context.errors = []
    end

    def call
      context.bucket = create_bucket
    rescue StandardError
      add_error
    end

    private

    def create_bucket
      context.creator.buckets.create!(name: context.name,
                                      bucket_type: Bucket.bucket_types[context.type],
                                      expected_enrollment: context.expected_enrollment)
    end

    def add_error
      context.errors.push(I18n.t('interactors.bucket_interactors.creation_performer.errors.main_error'))
    end
  end
end
