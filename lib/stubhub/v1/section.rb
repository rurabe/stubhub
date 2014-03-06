module Stubhub
  module V1
    class Section < Document
      class << self
        def find_by_event_id(event_id)
          response = client.make_request('search/inventory/v1/sectionsummary',eventId: event_id)
          raise ApiError.new(error_message(response)) if error_message(response)
          response['section']
        end
        private
          def error_message(response)
            response["errors"]["error"][0]["errorMessage"]
          rescue
          end
      end

    end
  end
end