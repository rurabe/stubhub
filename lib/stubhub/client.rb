module Stubhub
  class Client
    BASE_URL = "https://api.stubhub.com"

    class << self
      def make_request(endpoint,query={},opts={})
        JSON.parse(fetch_response("#{BASE_URL}/#{endpoint}",query,opts).body)
      end

      private

          def fetch_response(url,query,opts)
            uri,request = new_request(url,query,opts)
            net = Net::HTTP.new(uri.hostname,uri.port)
            net.use_ssl = true
            net.start {|http| http.request(request) }
          end

          def new_request(url,query,opts)
            uri = URI(url)
            opts[:headers] ||= {}
            request = case opts[:method]
            when /post/i
              opts[:headers][:content_type] = 'application/json'
              set_headers!(Net::HTTP::Post.new(uri),opts).tap do |r|
                r.body = query.to_json
              end
            else # get request
              uri.query = URI.encode_www_form(default_params.merge(query))
              set_headers!(Net::HTTP::Get.new(uri),opts)
            end
            [uri,request]
          end

          def set_headers!(request,opts)
            headers = default_headers(opts).merge(opts[:headers])
            headers.each do |k,v|
              key = k.to_s.split(/[\s\-\_]/).map(&:capitalize).join('-')
              request[key] = v
            end
            request
          end

          def default_headers(opts)
            {
              :authorization   => "Bearer #{auth_token(opts)}",
              :accept          => 'application/json',
              :accept_encoding => 'application/json'
            }
          end

          def default_params
            {rows: 99999}
          end

          def auth_token(opts)
            if opts[:context] == :user
              Stubhub.consumer_token  
            else
              Stubhub.application_token
            end
          end

    end
  end
end