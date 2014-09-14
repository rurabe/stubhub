  module Stubhub
    class Document

      def self.find(params={},options = {})
        params.merge!( :stubhubDocumentType => demodulize.downcase )
        client.make_request(self,params,options) if ancestors[1] == Stubhub::Document
      end

      def self.demodulize
        to_s.gsub(/^.*::/, '')
      end

      def self.client
        Client
      end

      def self.proxy_client
        ProxyClient
      end

    end
  end
