module Stubhub
  module V1
    module Catalog
      class Events < Response
        
        class << self
          def find_by_event_id(event_id)
            data = client.make_request("catalog/events/v1/#{event_id}/metadata/inventoryMetaData")
            new(data)
          end
        end

        def metadata
          @data["InventoryEventMetaData"]
        end

      end
    end
  end
end
