module Stubhub
  module V1
    class Client
      BASE_URL = "https://api.stubhub.com"

      class << self
        def make_request(endpoint,query={},opts={})
          raise StandardError.new("STUBHUB_APP_KEY must be set in the ENV") unless ENV['STUBHUB_APP_KEY']
          response = fetch_response("#{BASE_URL}/#{endpoint}",query,opts)
          JSON.parse(response.body)
        end

        private

          def default_params
            {rows: 99999}
          end

          def fetch_response(url,query,opts)
            uri,request = new_request(url,query,opts)
            net = Net::HTTP.new(uri.hostname,uri.port)
            # net.set_debug_output $stderr
            net.use_ssl = true
            net.start {|http| http.request(request) }
          end

          def new_request(url,query,opts)
            uri = URI(url)
            request = case opts[:method]
            when /post/i
              set_headers!(Net::HTTP::Post.new(uri),opts).tap do |r|
                r.body = query.to_json
                r.content_type = 'application/json'
              end
            else # get request
              uri.query = URI.encode_www_form(default_params.merge(query))
              set_headers!(Net::HTTP::Get.new(uri),opts)
            end
            [uri,request]
          end

          def set_headers!(request,opts)
            request.tap do |r|
              r['Authorization'] = "Bearer #{auth_token(opts)}"
              r['Accept'] = 'application/json'
              r['Accept-Encoding'] = 'application/json'
            end
          end

          def auth_token(opts)
            if opts[:context] == :user
              ENV['STUBHUB_USER_TOKEN']  
            else
              ENV['STUBHUB_APP_KEY']
            end
              
          end

      end
    end
  end
end