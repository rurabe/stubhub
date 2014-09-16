module Stubhub
  class ProxyClient < Client
    class << self
      def get(url,opts={})
        uri = URI(url)
        Net::HTTP.new(uri.host,uri.port,ENV['PROXY_ADDRESS'],ENV['PROXY_PORT']).start do |http|
          http.get(uri)
        end
      end

    end
  end
end