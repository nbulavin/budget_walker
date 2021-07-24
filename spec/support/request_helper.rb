# frozen_string_literal: true

module Support
  module RequestHelper
    def response_json
      JSON.parse(response.body)
    end
  end
end
