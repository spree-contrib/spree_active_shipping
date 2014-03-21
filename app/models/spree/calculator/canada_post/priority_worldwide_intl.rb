# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  module Calculator
    module CanadaPost
      class PriorityWorldwideIntl < Spree::Calculator::Shipping::CanadaPost::PriorityWorldwideIntl
      end
    end
  end
end