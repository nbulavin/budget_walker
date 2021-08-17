# frozen_string_literal: true

module BucketInteractors
  class CreationPerformer
    class MissingUserError < StandardError
    end

    include Interactor

    before do
      context.user = context.payload[:user]
      context.errors = []
    end

    def call
      raise MissingUserError unless context.user

      context.bucket = create_bucket
    rescue MissingUserError
      add_error('Вы не авторизованы')
    rescue StandardError
      add_error(I18n.t('interactors.bucket_interactors.creation_performer.errors.main_error'))
    end

    private

    def create_bucket
      Bucket.create!(context.payload)
    end

    def add_error(text)
      context.errors.push(text)
      context.fail!
    end
  end
end
