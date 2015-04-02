module Spree
  module ActiveShipping
    # Bogus carrier useful for testing.  For some reasons the plugin version of this class does not work
    # properly (it fails to return a RateResponse)
    class BogusCarrier < ::ActiveShipping::Carrier
      def name
        "BogusCarrier"
      end

      def find_rates(origin, destination, packages, options = {})
        RateResponse.new(true, "Bogus rate response.")
      end
    end
  end
end
