module Stubhub
  class User
    class << self

      def get_token(opts={})
        request = generate_request(opts, grant_type: 'password')
        response = parse_response(Client.make_basic_request('login',{}, opts.merge(request: request) ))
        set_params!(response)
      end

      def refresh_token(opts={})
        opts[:refresh_token] ||= get_token["refresh_token"]
        request = generate_request(opts, grant_type: 'refresh_token', refresh_token: opts[:refresh_token])
        response = parse_response(Client.make_basic_request('login',{}, opts.merge(request: request) ))
        set_params!(response)
      end

      private

        def generate_request(opts={},form_data={})
          opts[:key]      ||= Stubhub.consumer_key
          opts[:secret]   ||= Stubhub.consumer_secret
          opts[:username] ||= Stubhub.developer_username
          opts[:password] ||= Stubhub.developer_password
          basic_authorization_token = Base64.strict_encode64("#{opts[:key]}:#{opts[:secret]}").strip
          Net::HTTP::Post.new(URI("https://api.stubhub.com/login")).tap do |r|
            r['Content-Type']  = "application/x-www-form-urlencoded"
            r['Authorization'] = "Basic #{basic_authorization_token}"
            r.set_form_data(default_form_data(opts).merge(form_data))
          end
        end

        def default_form_data(opts)
          {
            username: opts[:username],
            password: opts[:password],
            scope:    'PRODUCTION'
          }
        end

        def parse_response(response)
          JSON.parse(response.body).merge("user_id" => response['X-StubHub-User-GUID']) if response.body
        end

        def set_params!(params)
          Stubhub.configure({}.tap do |c|
            c[:consumer_token] = params['access_token'] if params['access_token']
            c[:user_id]        = params['user_id'] if params['user_id']
          end)
          params
        end
    end
  end
end