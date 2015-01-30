module Stubhub
  module Pricing
    module AIP
      class V1 < Response
        class << self

          # This method requires you to structure the individual listing requests the way they want it yourself
          def price_listings(listings,opts={})
            response = Client.make_request(
              'pricing/aip/v1/price',
              prepare_pricing_query(listings),
              opts.merge(method: :post, context: :user)
            )
          end

          private
             def prepare_pricing_query(listings)
                {
                  priceRequestList: {
                    priceRequest: listings
                  }
                }
              end

          end # /self

        def listing_price_for(request_key)
          price_response = response_for(request_key)
          price_response['listingPrice']['amount'] if price_response
        end

        def response_for(request_key)
          self['priceResponseList']['priceResponse'].find{|pr| pr['requestKey'] == request_key.to_s }
        end
      end
    end
  end
end