class Spree::Admin::ActiveShippingSettingsController < Spree::Admin::BaseController
  def edit
    @config = Spree::ActiveShipping::Config

    @preferences_GeneralSettings = [:units, :unit_multiplier, :default_weight, :handling_fee,
                                    :max_weight_per_package, :test_mode]
  end

  def update
    config = Spree::ActiveShipping::Config

    params.each do |name, value|
      next unless config.has_preference? name
      config[name] = value
    end

    redirect_to edit_admin_active_shipping_settings_path
  end
end
