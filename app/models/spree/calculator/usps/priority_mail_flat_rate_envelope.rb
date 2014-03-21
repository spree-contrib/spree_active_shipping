# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  module Calculator
    module Usps
      class PriorityMailFlatRateEnvelope < Spree::Calculator::Shipping::Usps::PriorityMailFlatRateEnvelope
      end
    end
  end
end