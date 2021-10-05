# frozen_string_literal: true

module Support
  module RequestHelper
    def response_json
      JSON.parse(response.body)
    end

    def response_json_object
      JSON.parse(response.body, object_class: OpenStruct)
    end
  end
end
