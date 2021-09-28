# frozen_string_literal: true

module IncomeCategoryContracts
  class OnCreationContract < ApplicationContract
    config.messages.namespace = :income_category_validation

    params do
      required(:user).filled(type?: User)
      required(:name).filled(:string)
      optional(:expected_revenue).maybe(:integer)
    end
  end
end
