module Stubhub
  module V1
    module Search
      class Inventory < Response

        class << self
          def find_by_event_id(id)
            data = client.make_request('search/inventory/v1',eventId: id, sectionStats: true)
            new(data)
          end
        end

        def listings
          @data['listing']
        end

        def sections
          @data['section_stats']
        end

      end
    end
  end
end  