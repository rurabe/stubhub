module Stubhub
  module LCS
    class Client
      BASE_URL = 'http://partner-feed.stubhub.com'

        class << self
          def make_request(klass, params, options={})
            result = make_unparsed_request(klass,params,options)
            parse(result.body)
          end

          def make_unparsed_request(klass,params,options={})
            path = options.delete(:path) || "listingCatalog/select"
            query = prepare_query(params, options)
            get("#{BASE_URL}/#{path}/?#{query}",options)
          end

          def prepare_query(params, options={})
            query = {:q => solr_dump(params) }
            hash_to_params( defaults.merge(options).merge(query) )
          end

          def solr_dump(params)
            params.map do |k,v|
              case v
              when Array then "#{k}:(#{v.join(" OR ")})"
              else "#{k}:\"#{v}\""
              end
            end.join(' AND ')
          end

          def hash_to_params(params={})
            params.map do |k,v|
              "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
            end.join("&")
          end

          def parse(body)
            JSON.parse(body)["response"]["docs"]
          end

          def defaults
            {
              :rows => 999999,
              :wt   => "json"
            }
          end

          private

            def get(url,options={})
              uri = URI(url)
              new_request(uri,options).tap do |http|
                http.set_debug_output $stdout
              end.start do |http|
                http.get(uri)
              end
            end

            def new_request(uri,options)
              if Stubhub.proxy_address && (options[:proxy] != false)
                Net::HTTP.new(uri.host,uri.port,*Stubhub.proxy_attributes)
              else
                Net::HTTP.new(uri.host,uri.port)
              end
            end
        end

    end
  end
end

# http://partner-feed.stubhub.com/listingCatalog/select/?q=stubhubDocumentType:event