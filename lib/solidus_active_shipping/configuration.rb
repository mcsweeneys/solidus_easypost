module SolidusActiveShipping
  class Configuration < Spree::Preferences::Configuration

    preference :units, :string, default: 'imperial'
    preference :unit_multiplier, :decimal, default: 16 # 16 oz./lb - assumes variant weights are in lbs
    preference :default_weight, :integer, default: 0 # 16 oz./lb - assumes variant weights are in lbs
    preference :handling_fee, :integer
    preference :max_weight_per_package, :integer, default: 0 # 0 means no limit


    # General
    preference :test_mode, :boolean, default: false
    preference :easypost_api_key, :string, default: 'eaypost_api_key'
  end
end
