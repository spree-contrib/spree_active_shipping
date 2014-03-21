# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  module Calculator
    module Usps
      class PriorityMailMediumFlatRateBox < Spree::Calculator::Shipping::Usps::PriorityMailMediumFlatRateBox
      end
    end
  end
end