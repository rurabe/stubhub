module Stubhub
  SETTINGS_LIST = [
    :application_token,
    :consumer_key,
    :consumer_secret,
    :developer_username,
    :developer_password,
    :consumer_token,
    :proxy_address,
    :proxy_port,
    :proxy_username,
    :proxy_password,
    :user_id
  ]

  class Settings
    attr_accessor *SETTINGS_LIST

    def initialize
      SETTINGS_LIST.each {|k| send("#{k}=",ENV["STUBHUB_#{k.to_s.upcase}"]) }
    end
  end

  class << self
    def configure(settings_hash={})
      settings_hash.each {|k,v| settings.send("#{k}=",v) }
      yield(settings) if block_given?
      return self
    end

    SETTINGS_LIST.each do |k|
      define_method(k) do
        settings.send(k)
      end
    end

    def proxy_attributes
      [:proxy_address,:proxy_port,:proxy_username,:proxy_password].map {|m| settings.send(m) }
    end

    def enable_debug_output=(setting)
      @enable_debug_output = setting
    end

    def enable_debug_output?
      @enable_debug_output
    end

    private

      def settings
        @settings ||= Settings.new
      end
  end
end