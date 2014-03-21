# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  module Calculator
    module Ups
      class Saver < Spree::Calculator::Shipping::Ups::Saver
      end
    end
  end
end