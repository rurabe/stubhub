module Stubhub
  module Catalog
    module Events
      class V2 < Response
        
        class << self
          def find_by_event_id(event_id,opts={})
            response = Client.make_request("catalog/events/v2/#{event_id}",{},opts)
            self[response]
          end
        end # /self

      end
    end
  end
end