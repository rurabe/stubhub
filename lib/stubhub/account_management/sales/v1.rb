module Stubhub
  module AccountManagement
    module Sales
      class V1
        class << self
          def get_sales(opts={})
            Client.make_request("accountmanagement/sales/v1/seller/#{Stubhub.user_id}",query(opts),opts.merge(context: :user))
          end

          private

            def query(opts)
              {
                rows: 200,
                includePending: true,
                sort: "SALEDATE Desc"
              }.merge(opts[:query] || {})
            end
        end

      end
    end
  end
end