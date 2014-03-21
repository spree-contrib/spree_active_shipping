# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  module Calculator
    module Usps
      class ExpressMailInternational < Spree::Calculator::Shipping::Usps::ExpressMailInternational
      end
    end
  end
end