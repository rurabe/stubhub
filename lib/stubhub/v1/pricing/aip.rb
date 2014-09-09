module Stubhub
  module V1
    module Pricing
      class AIP < Response
        class << self
          # Takes an array of arrays: ids and prices
          # [[2131412,100.00],[5256234,90.00]]
          def price_by_listing_id(*listings)
            data = client.make_request('pricing/aip/v1/price',prepare_query(listings),{method: :post,context: :user})
            new(data)
          end

          private

            def prepare_query(listings)
              {
                priceRequestList: {
                  priceRequest: prepare_price_requests(listings)
                }
              }
            end

            def prepare_price_requests(listings)
              listings.each_with_index.map do |listing,key|
                prepare_price_request(listing,key)
              end
            end

            def prepare_price_request(listing,key)
              id = listing.first
              price = listing.last
              {
                requestKey: key,
                listingId: listing.first,
                amountPerTicket: {
                  amount: price,
                  currency: "USD"
                },
                amountType: "DISPLAY_PRICE",
                sellerId: 6686104,
              }
            end
        end


      end
    end
  end
end  