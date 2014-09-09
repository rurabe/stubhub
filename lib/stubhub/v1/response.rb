module Stubhub
  module V1
    class Response
      attr_reader :data
      def self.client
        Stubhub::V1::Client
      end

      def initialize(data={})
        @data = data
      end

      def failed?
        !!@data["errors"]
      end
    end
  end
end