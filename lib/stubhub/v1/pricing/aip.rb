module Stubhub
  module V1
    module Pricing
      class AIP < Response
        class << self
          # Takes an array of arrays: ids and prices
          # [[2131412,100.00],[5256234,90.00]]
          def price_display_prices(*listings)
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
              listings.map do |listing|
                prepare_price_request(listing)
              end
            end

            def prepare_price_request(listing)
              id = listing.first
              price = listing.last
              {
                requestKey: id,
                listingId: id,
                amountPerTicket: {
                  amount: price,
                  currency: "USD"
                },
                amountType: "DISPLAY_PRICE",
                sellerId: 6686104,
              }
            end
        end

        def listing_prices
          Hash[price_responses.map{|r| [r["requestKey"],r["listingPrice"]["amount"]] }]
        end

        def listing_price_for(requestKey)
          listing_prices[requestKey.to_s]
        end

        def response_for(requestKey)
          price_responses.find{|r| r["requestKey"] == requestKey.to_s }
        end

        private

          def price_responses
            data["priceResponseList"]["priceResponse"]
          end


      end
    end
  end
end  