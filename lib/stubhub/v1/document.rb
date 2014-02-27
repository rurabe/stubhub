module Stubhub
  module V1
    class Document < Stubhub::Document
      def self.client
        Stubhub::V1::Client
      end
    end
  end
end