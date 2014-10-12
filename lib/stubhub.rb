require 'json'
require 'uri'
require 'net/http'
require 'base64'

require_relative 'stubhub/version'

require_relative 'stubhub/settings'
require_relative 'stubhub/api_error'
require_relative 'stubhub/user'
require_relative 'stubhub/client'


require_relative 'stubhub/lcs/document'
require_relative 'stubhub/lcs/client'
require_relative 'stubhub/lcs/proxy_client'
require_relative 'stubhub/lcs/event'
require_relative 'stubhub/lcs/genre'
require_relative 'stubhub/lcs/geo'
require_relative 'stubhub/lcs/ticket'
require_relative 'stubhub/lcs/venue'
require_relative 'stubhub/lcs/venue_zone_section'

require_relative 'stubhub/catalog/events/v2'
require_relative 'stubhub/catalog/venues/v2'

require_relative 'stubhub/v1/client'
require_relative 'stubhub/v1/response'
require_relative 'stubhub/v1/search/inventory'
require_relative 'stubhub/v1/catalog/events'
require_relative 'stubhub/v1/pricing/aip'

module Stubhub

end