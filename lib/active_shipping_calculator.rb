class ActiveShippingCalculator
  #include Spree::ActiveShipping    
  include ActiveMerchant::Shipping
  
  #def initialize(carrier)
  #  @carrier = carrier.new
  #end
  
  def calculate_shipping(order)
    origin      = Location.new(:country => Spree::ActiveShipping::Config[:origin_country], 
                               :city => Spree::ActiveShipping::Config[:origin_city],
                               :state => Spree::ActiveShipping::Config[:origin_state],
                               :zip => Spree::ActiveShipping::Config[:origin_zip])

    destination = Location.new(:country => order.address.country.iso,
                               :state => order.address.state.abbr,
                               :city => order.address.city,
                               :zip => order.address.zipcode)

    rates = Rails.cache.fetch(order) do                              
      rates = retrieve_rates(origin, destination, packages(order))
    end
    
    return nil unless rates    
    rate = rates[rate_name]
    return nil unless rate
    # divide by 100 since active_shipping rates are expressed as cents
    return rate/100 
  end

  protected 
  def rate_name
  end
  
  private  
  def retrieve_rates(origin, destination, packages)
    begin
      response = carrier.find_rates(origin, destination, packages)
      # turn this beastly array into a nice little hash
      Hash[*response.rates.collect { |rate| [rate.service_name, rate.price] }.flatten]
    rescue ActiveMerchant::Shipping::ResponseError => re     
      msg = "#{Globalite.loc(:shipping_error)}: #{re.message}"
      raise Spree::ShippingError.new(msg)
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