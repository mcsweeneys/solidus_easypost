module SolidusActiveShipping
  class Configuration < Spree::Preferences::Configuration
    # General
    preference :test_mode, :boolean, default: false

    preference :easypost_api_key, :string, default: 'eaypost_api_key'
  end
end
