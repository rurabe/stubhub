module Stubhub
  module V1
    class Section < Document
      def self.find_by_event_id(event_id)
        response = client.make_request('search/inventory/v1/sectionsummary',eventId: event_id)
        response['section'].map{ |data| new(data) }
      end

    end
  end
end