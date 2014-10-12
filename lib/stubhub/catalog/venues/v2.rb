module Stubhub
  module Catalog
    module Venues
      class V2
        class << self
          def find_by_venue_id(venue_id,opts={})
            Client.make_request("catalog/venues/v2/#{venue_id}",{},opts)
          end
        end
      end
    end
  end
end
