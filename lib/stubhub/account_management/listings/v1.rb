module Stubhub
  module AccountManagement
    module Listings
      class V1
        class << self
          def find_by_listing_id(listing_id,opts={})
            Client.make_request("accountmanagement/listings/v1/#{listing_id}",query(opts),opts.merge(context: :user))
          end

          def get_listings(opts={})
            Client.make_request("accountmanagement/listings/v1/seller/#{Stubhub.user_id}",query(opts),opts.merge(context: :user))
          end

          private

            def query(opts)
              opts[:query] || {}
            end
        end

      end
    end
  end
end