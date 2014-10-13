module Stubhub
  module Search
    module Inventory
      class V1 < Response
        class << self
          def find_by_event_id(event_id,opts={})
            self[Client.make_request('search/inventory/v1',query(event_id,opts),opts)]
          end

          private

            def query(event_id,opts)
              (opts[:query] || {}).merge(eventId: event_id)
            end
        end # /self

        def listings
          self['listing'] || []
        end

        def sections
          self['section_stats'] || []
        end

      end
    end
  end
end