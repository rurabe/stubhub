module Stubhub
  class Client

    class << self
      def make_request(endpoint,query={},opts={})
        JSON.parse(make_basic_request(endpoint,query,opts).body)
      end

      def make_basic_request(endpoint,query={},opts={})
        fetch_response("#{base_url(opts)}/#{endpoint}",query,opts)
      end

      private

          def fetch_response(url,query,opts)
            uri,request = new_request(url,query,opts)
            http = new_http_session(uri,opts)
            http.use_ssl = true unless opts[:ssl] == false
            # http.set_debug_output $stderr # for debug sessions
            http.start {|http| http.request(request) }
          end

          def new_http_session(uri,opts)
            pa = opts[:proxy_address] || Stubhub.proxy_address
            if pa && (opts[:proxy] != false)
              pp = opts[:proxy_port] || Stubhub.proxy_port
              pu = opts[:proxy_username] || Stubhub.proxy_username
              pw = opts[:proxy_password] || Stubhub.proxy_password
              Net::HTTP.new(uri.hostname,uri.port,pa,pp,pu,pw)
            else
              Net::HTTP.new(uri.hostname,uri.port)
            end
          end

          def new_request(url,query,opts)
            uri = URI(url)
            opts[:headers] ||= {}
            request = opts[:request] || case opts[:method]
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

          def base_url(opts)
            opts[:base_url] || "https://api.stubhub.com"
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