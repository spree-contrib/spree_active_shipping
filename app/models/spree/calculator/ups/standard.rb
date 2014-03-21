# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  module Calculator
    module Ups
      class Standard < Spree::Calculator::Shipping::Ups::Standard
      end
    end
  end
end