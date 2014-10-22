module Stubhub
  class User
    class << self

      def get_token(opts={})
        opts[:key]      ||= Stubhub.consumer_key
        opts[:secret]   ||= Stubhub.consumer_secret
        opts[:username] ||= Stubhub.developer_username
        opts[:password] ||= Stubhub.developer_password
        response = Client.make_basic_request('login',{}, opts.merge(request: generate_request(opts)) )
        JSON.parse(response.body).merge("user_id" => response['X-StubHub-User-GUID']) if response.body
      end

      def login!(opts={})
        login_hash = get_token(opts)
        Stubhub.configure(
          consumer_token: login_hash["access_token"],
          user_id: login_hash["user_id"]
        )
        true
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