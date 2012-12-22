class Spree::Admin::ActiveShippingSettingsController < Spree::Admin::BaseController

  def show
    @config = Spree::ActiveShippingConfiguration.new
  end

  def edit
    @config = Spree::ActiveShippingConfiguration.new
  end

  def update
    config = Spree::ActiveShippingConfiguration.new

    params.each do |name, value|
      next unless config.has_preference? name
      config[name] = value
    end

    redirect_to admin_active_shipping_settings_path
  end

end


