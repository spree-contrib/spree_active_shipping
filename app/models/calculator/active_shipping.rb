include ActiveMerchant::Shipping

# This is a base calculator for shipping calcualations using the ActiveShipping plugin.  It is not intended to be
# instantiated directly.  Create sublcass for each specific shipping method you wish to support instead.
class Calculator::ActiveShipping < Calculator

  def self.register
    super
    ShippingMethod.register_calculator(self)
    ShippingRate.register_calculator(self)
  end

  def compute(line_items)
    order = line_items.first.order
    origin      = Location.new(:country => Spree::ActiveShipping::Config[:origin_country],
                               :city => Spree::ActiveShipping::Config[:origin_city],
                               :state => Spree::ActiveShipping::Config[:origin_state],
                               :zip => Spree::ActiveShipping::Config[:origin_zip])

    destination = Location.new(:country => order.ship_address.country.iso,
                               :state => order.ship_address.state.abbr,
                               :city => order.ship_address.city,
                               :zip => order.ship_address.zipcode)

    rates = Rails.cache.fetch(order) do
      rates = retrieve_rates(origin, destination, packages(order))
    end

    return nil unless rates
    rate = rates[self.description].to_f + (Spree::ActiveShipping::Config[:handling_fee].to_f || 0.0)
    return nil unless rate
    # divide by 100 since active_shipping rates are expressed as cents
    return rate/100
  end

  private
  def retrieve_rates(origin, destination, packages)
    begin
      response = carrier.find_rates(origin, destination, packages)
      # turn this beastly array into a nice little hash
      Hash[*response.rates.collect { |rate| [rate.service_name, rate.price] }.flatten]
    rescue ActiveMerchant::Shipping::ResponseError => re
      params = re.response.params
      if params.has_key?("Response") && params["Response"].has_key?("Error") && params["Response"]["Error"].has_key?("ErrorDescription")
        message = params["Response"]["Error"]["ErrorDescription"]
      else
        message = re.message
      end

      raise Spree::ShippingError.new("#{I18n.t('shipping_error')}: #{message}")
    end
  end

  # Generates an array of Package objects based on the quantities and weights of the variants in the line items
  def packages(order)
    multiplier = Spree::ActiveShipping::Config[:unit_multiplier]
    weight = order.line_items.inject(0) do |weight, line_item|
      line_item.variant.weight ? weight + (line_item.quantity * line_item.variant.weight * multiplier) : 0
    end
    package = Package.new(weight, [], :units => Spree::ActiveShipping::Config[:units].to_sym)
    [package]
  end
end
