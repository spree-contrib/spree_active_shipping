# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class ThreeDayFreightSaturdayDelivery < Spree::Calculator::Shipping::Fedex::ThreeDayFreightSaturdayDelivery
      end
    end
  end
end