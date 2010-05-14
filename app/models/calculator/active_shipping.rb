# This is a base calculator for shipping calcualations using the ActiveShipping plugin.  It is not intended to be
# instantiated directly.  Create sublcass for each specific shipping method you wish to support instead.
class Calculator::ActiveShipping < Calculator

  include ActiveMerchant::Shipping

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

    addr = order.ship_address

    destination = Location.new(:country => addr.country.iso,
                              :state => (addr.state ? addr.state.abbr : addr.state_name),
                              :city => addr.city,
                              :zip => addr.zipcode)

    rates = Rails.cache.fetch(cache_key(line_items)) do
      rates = retrieve_rates(origin, destination, packages(order))
    end

    return nil if rates.empty?
    rate = rates[self.description].to_f + (Spree::ActiveShipping::Config[:handling_fee].to_f || 0.0)
    return nil unless rate
    # divide by 100 since active_shipping rates are expressed as cents

    return rate/100.0
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

      Rails.cache.write @cache_key, {} #write empty hash to cache to prevent constant re-lookups

      raise Spree::ShippingError.new("#{I18n.t('shipping_error')}: #{message}")
    end
  end

  # Generates an array of Package objects based on the quantities and weights of the variants in the line items
  def packages(order)
    multiplier = Spree::ActiveShipping::Config[:unit_multiplier]
    weight = order.line_items.inject(0) do |weight, line_item|
      weight + (line_item.variant.weight ? (line_item.quantity * line_item.variant.weight * multiplier) : 0)
    end
    package = Package.new(weight, [], :units => Spree::ActiveShipping::Config[:units].to_sym)
    [package]
  end

  def cache_key(line_items)
    order = line_items.first.order
    addr = order.ship_address
    @cache_key = "#{carrier.name}-#{order.number}-#{addr.country.iso}-#{addr.state ? addr.state.abbr : addr.state_name}-#{addr.city}-#{addr.zipcode}-#{line_items.map {|li| li.variant_id.to_s + "_" + li.quantity.to_s }.join("|")}"
  end
end
