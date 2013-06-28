module Spree
  module Calculator::Shipping
    module ActiveShipping
      # Bogus calculator for testing purposes.  Uses the common functionality of ActiveShippingCalcualtor but
      # doesn't actually use a real carrier to obtain rates.
      class BogusCalculator < Spree::Calculator::Shipping::ActiveShipping::Base
        def carrier
          Spree::ActiveShipping::BogusCarrier
        end

        def self.description
          "Bogus Calculator"
        end
      end
    end
  end
end