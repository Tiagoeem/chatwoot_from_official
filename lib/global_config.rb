class GlobalConfig
  VERSION = 'V1'.freeze
  KEY_PREFIX = 'GLOBAL_CONFIG'.freeze
  DEFAULT_EXPIRY = 1.day

  class << self
    def get(*args)
      config_keys = *args
      config = {}

      config_keys.each do |config_key|
        config[config_key] = load_from_cache(config_key)
      end

      typecast_config(config)
      config.with_indifferent_access
    end

    def get_value(arg)
      load_from_cache(arg)
    end

    def clear_cache
      cached_keys = $alfred.with { |conn| conn.keys("#{VERSION}:#{KEY_PREFIX}:*") }
      (cached_keys || []).each do |cached_key|
        $alfred.with { |conn| conn.expire(cached_key, 0) }
      end
    end

    private

    def typecast_config(config)
      general_configs = ConfigLoader.new.general_configs
      config.each do |config_key, config_value|
        config_type = general_configs.find { |c| c['name'] == config_key }&.dig('type')
        config[config_key] = ActiveRecord::Type::Boolean.new.cast(config_value) if config_type == 'boolean'
      end
    end

    def load_from_cache(config_key)
      cache_key = "#{VERSION}:#{KEY_PREFIX}:#{config_key}"
      cached_value = $alfred.with { |conn| conn.get(cache_key) }

      if cached_value.blank?
        value_from_db = db_fallback(config_key)
        cached_value = { value: value_from_db }.to_json
        $alfred.with { |conn| conn.set(cache_key, cached_value, { ex: DEFAULT_EXPIRY }) }
      end

      JSON.parse(cached_value)['value']
    end

    def db_fallback(config_key)
      custom_config_value = get_from_custom_config(config_key)
      return custom_config_value if custom_config_value.present?

      InstallationConfig.find_by(name: config_key)&.value
    end

    def get_from_custom_config(config_key)
      case config_key
      when 'BRAND_NAME'
        Rails.application.config.brand['name'] if Rails.application.config.respond_to?(:brand)
      when 'LOGO', 'LOGO_DARK', 'LOGO_THUMBNAIL'
        key = config_key.split('_').last.downcase
        Rails.application.config.brand["logo_#{key}"] if Rails.application.config.respond_to?(:brand)
      when 'WEBSITE'
        Rails.application.config.brand['website'] if Rails.application.config.respond_to?(:brand)
      when 'REPOSITORY'
        Rails.application.config.brand['repository'] if Rails.application.config.respond_to?(:brand)
      end
      when 'FAVICON'
        Rails.application.config.brand['favicon'] if Rails.application.config.respond_to?(:brand)
      end
    end
  end
end
