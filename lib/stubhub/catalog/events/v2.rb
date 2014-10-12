module Stubhub
  module Catalog
    module Events
      class V2
        class << self
          def find_by_event_id(event_id,opts={})
            Client.make_request("catalog/events/v2/#{event_id}",{},opts)
          end
        end
      end
    end
  end
end