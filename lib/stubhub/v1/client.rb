module Stubhub
  module V1
    class Client
      BASE_URL = "https://api.stubhub.com"

      class << self
        def make_request(endpoint,query)
          raise StandardError.new("STUBHUB_APP_KEY must be set in the ENV") unless ENV['STUBHUB_APP_KEY']
          uri = URI("#{BASE_URL}/#{endpoint}?#{prepare_query(query)}")
          request = Net::HTTP::Get.new(uri)
          request['Authorization'] = "Bearer #{ENV['STUBHUB_APP_KEY']}"
          request['Accept'] = 'application/json'
          request['Accept-Encoding'] = 'application/json'
          net = Net::HTTP.new(uri.hostname,uri.port)
          net.use_ssl = true if uri.scheme == 'https'
          net.start do |http|  
            JSON.load(http.request(request).body)
          end
        end

        def prepare_query(query={})
          params = default_params.merge(query)
          params.map do |k,v|
            "#{k}=#{v}"
          end.join("&")
        end

        def default_params
          {rows: 99999}
        end


      end
    end
  end
end