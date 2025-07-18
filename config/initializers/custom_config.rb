require 'yaml'

custom_config_file = Rails.root.join('custom_config.yml')

if File.exist?(custom_config_file)
  custom_config = YAML.load_file(custom_config_file)

  if custom_config && custom_config['brand']
    Rails.application.config.brand = custom_config['brand']
  end

  if custom_config && custom_config['theme']
    Rails.application.config.theme = custom_config['theme']
  end

  if custom_config && custom_config['sidebar_menu']
    Rails.application.config.sidebar_menu = custom_config['sidebar_menu']
  end
end
