# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  module Calculator
    module Fedex
      class OneDayFreightSaturdayDelivery < Spree::Calculator::Shipping::Fedex::OneDayFreightSaturdayDelivery
      end
    end
  end
end