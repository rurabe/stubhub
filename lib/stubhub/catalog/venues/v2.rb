module Stubhub
  module Catalog
    module Venues
      class V2 < Response
        
        class << self
          def find_by_venue_id(venue_id,opts={})
            response = Client.make_request("catalog/venues/v2/#{venue_id}",{},opts)
            self[response]
          end
        end # /self

      end
    end
  end
end
