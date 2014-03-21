# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  module Calculator
    module Ups
      class NextDayAir < Spree::Calculator::Shipping::Ups::NextDayAir
      end
    end
  end
end