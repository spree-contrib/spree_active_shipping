# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  module Calculator
    module Usps
      class PriorityMailInternationalMediumFlatRateBox < Spree::Calculator::Shipping::Usps::PriorityMailInternationalMediumFlatRateBox
      end
    end
  end
end