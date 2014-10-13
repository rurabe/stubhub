module Stubhub
  class User
    class << self

      def get_token(opts={})
        opts[:key]      ||= Stubhub.consumer_key
        opts[:secret]   ||= Stubhub.consumer_secret
        opts[:username] ||= Stubhub.developer_username
        opts[:password] ||= Stubhub.developer_password
        Client.make_request('login',{}, opts.merge(request: generate_request(opts)) )
      end

      def login!(opts={})
        get_token(opts)["access_token"].tap {|token|  Stubhub.configure(consumer_token: token) }
      end

      private

        def generate_request(opts)
          basic_authorization_token = Base64.strict_encode64("#{opts[:key]}:#{opts[:secret]}").strip
          Net::HTTP::Post.new(URI("https://api.stubhub.com/login")).tap do |r|
            r['Content-Type']  = "application/x-www-form-urlencoded"
            r['Authorization'] = "Basic #{basic_authorization_token}"
            r.set_form_data(
              grant_type: 'password',
              username: opts[:username],
              password: opts[:password],
              scope: 'PRODUCTION'
            )
          end
        end
    end
  end
end