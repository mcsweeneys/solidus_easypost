module SolidusActiveShipping
  class Configuration < Spree::Preferences::Configuration
    # Easypost
    preference :easypost_api_key, :string, default: 'fakefakefake'

    # UPS
    preference :ups_login, :string, default: 'aunt_judy'
    preference :ups_password, :string, default: 'secret'
    preference :ups_key, :string, default: 'developer_key'
    preference :shipper_number, :string, default: nil

    # Fedex
    preference :fedex_login, :string, default: 'meter_no'
    preference :fedex_password, :string, default: 'special_sha1_looking_thing_sent_via_email'
    preference :fedex_account, :string, default: 'account_no'
    preference :fedex_key, :string, default: 'authorization_key'

    # USPS
    preference :usps_login, :string, default: 'aunt_judy'
    preference :units, :string, default: 'imperial'
    preference :unit_multiplier, :decimal, default: 16 # 16 oz./lb - assumes variant weights are in lbs
    preference :default_weight, :integer, default: 0 # 16 oz./lb - assumes variant weights are in lbs
    preference :handling_fee, :integer
    preference :max_weight_per_package, :integer, default: 0 # 0 means no limit

    # Canada Post
    # The default values correspond to the official test credentials
    # Source : https://www.canadapost.ca/cpo/mc/business/productsservices/developers/services/fundamentals.jsf
    preference :canada_post_login, :string, default: 'canada_post_login'
    preference :canada_post_pws_userid, :string, default: '6e93d53968881714'
    preference :canada_post_pws_password, :string, default: '0bfa9fcb9853d1f51ee57a'
    preference :canada_post_pws_customer_number, :string, default: '2004381'
    preference :canada_post_pws_contract_number, :string, default: '42708517'

    # General
    preference :test_mode, :boolean, default: false

    preference :easypost_login, :string, default: 'eaypost_login'
    preference :easypost_api_key, :string, default: 'eaypost_api_key'
  end
end
