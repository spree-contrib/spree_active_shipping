# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  module Calculator
    module Fedex
      class ThreeDayFreightSaturdayDelivery < Spree::Calculator::Shipping::Fedex::ThreeDayFreightSaturdayDelivery
      end
    end
  end
end