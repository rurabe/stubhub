module Stubhub
  class Login
    class << self

      def get_token(key=nil,secret=nil,username=nil,password=nil)
        key      ||= ENV['STUBHUB_CONSUMER_KEY']
        secret   ||= ENV['STUBHUB_CONSUMER_SECRET']
        username ||= ENV['STUBHUB_USERNAME']
        password ||= ENV['STUBHUB_PASSWORD']
        request = generate_request(key,secret,username,password)
        response = send_request(request)
        parse_response(response)
      end

      private

        def generate_request(key,secret,username,password)
          basic_authorization_token = Base64.strict_encode64("#{key}:#{secret}").strip
          request = Net::HTTP::Post.new(uri).tap do |r|
            r['Content-Type']  = "application/x-www-form-urlencoded"
            r['Authorization'] = "Basic #{basic_authorization_token}"
            r.set_form_data(
              grant_type: 'password',
              username: username,
              password: password,
              scope: 'PRODUCTION'
            )
          end
        end

        def send_request(request)
          net = Net::HTTP.new(uri.hostname,uri.port)
          net.use_ssl = true
          net.start {|http| http.request(request) }
        end

        def parse_response(response)
          return {} unless response.body
          JSON.parse(response.body).inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
        end

        def uri
          URI("https://api.stubhub.com/login")
        end
    end
  end
end