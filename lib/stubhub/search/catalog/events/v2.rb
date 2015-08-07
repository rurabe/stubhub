module Stubhub
  module Search
    module Catalog
      module Events
        class V2 < Response
          
          class << self
            def find_by_venue_id(venue_id,query={},opts={})
              self[Client.make_request('search/catalog/events/v2',query.merge(venue_id: venue_id),opts)]
            end
          end # /self

          def events
            self['events'] || []
          end
        end
      end
    end
  end
end
