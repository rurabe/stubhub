module Stubhub
  module LCS
    class Ticket < Document

      def self.find_by_ticket_id(ticket_id, options = {})
        params = { :id => ticket_id }
        find(params,options).first
      end

      def self.client
        Stubhub.proxy_address ? ProxyClient : Client
      end

    end
  end
end