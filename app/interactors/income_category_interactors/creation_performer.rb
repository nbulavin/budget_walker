# frozen_string_literal: true

module IncomeCategoryInteractors
  class CreationPerformer < ApplicationInteractor
    class InvalidPayloadError < StandardError
    end

    before do
      context.errors = {}
    end

    def call
      result = prepare_payload
      raise InvalidPayloadError unless result.success?

      context.income_category = create_income_category(result.to_h)
    rescue InvalidPayloadError
      add_error(result.errors.to_h)
    rescue StandardError
      add_error({ common: [I18n.t('interactors.income_category_interactors.creation_performer.errors.main_error')] })
    end

    private

    def prepare_payload
      IncomeCategoryContracts::OnCreationContract.new.call(**context.payload)
    end

    def create_income_category(formatted_payload)
      IncomeCategory.create!(formatted_payload)
    end

    def add_error(error_hash)
      context.errors = error_hash
      context.fail!
    end
  end
end
