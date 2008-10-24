module Spree
  # Bogus carrier useful for testing.  For some reasons the ActiveShipping version of this class does not work 
  # properly (it fails to return a valid Response)
  class BogusCarrier < ActiveMerchant::Shipping::Carrier
    def find_rates(origin, destination, packages, options = {})
      RateResponse.new(true, "Bogus rate response.")
    end
  end 
end