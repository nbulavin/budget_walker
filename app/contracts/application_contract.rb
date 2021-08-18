# frozen_string_literal: true

class ApplicationContract < Dry::Validation::Contract
  config.messages.default_locale = :ru
  config.messages.backend = :i18n
end
