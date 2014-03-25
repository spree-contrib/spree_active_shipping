# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  class Calculator < ActiveRecord::Base
    module Usps
      class PriorityMailInternationalSmallFlatRateBox < Spree::Calculator::Shipping::Usps::PriorityMailInternationalSmallFlatRateBox
      end
    end
  end
end