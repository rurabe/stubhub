module Stubhub
  module Pricing
    module AIP
      class V1 < Response
        class << self

          # First parameter is an array of hashes, each including
          #   :listing_id => the stubhub_id of the listing being priced,
          #   :price      => the display_price
          # Optionally, a type can be specified, which overrides the type hardcoded here
          #   :type       => [:display,:listing,:payout]
          #
          def price_listing_as_display_price(listings,opts={})
            response = Client.make_request(
              'pricing/aip/v1/price',
              prepare_pricing_query(listings: listings, type: :display),
              opts.merge(method: :post, context: :user)
            )
            self[response]
          end

          private
             def prepare_pricing_query(params={})
                {
                  priceRequestList: {
                    priceRequest: prepare_price_requests(params)
                  }
                }
              end

              def prepare_price_requests(params)
                params[:listings].map do |listing|
                  prepare_price_request(listing,params)
                end
              end

              def prepare_price_request(listing,params)
                id = listing[:listing_id]
                price = listing[:price]
                {
                  requestKey: id,
                  listingId: id,
                  amountPerTicket: {
                    amount: price,
                    currency: "USD"
                  },
                  amountType: price_type(listing,params),
                  sellerId: 6686104,
                }
              end

              def price_type(listing,params)
                case (listing[:type] || params[:type])
                when :display then "DISPLAY_PRICE"
                when :listing then "LISTING_PRICE"
                when :payout  then "PAYOUT"
                end
              end

          end # /self

        def listing_price_for(request_key)
          price_response = self['priceResponseList']['priceResponse'].find{|pr| pr['requestKey'] == request_key.to_s }
          price_response['displayPrice']['amount'] if price_response
        end
      end
    end
  end
end