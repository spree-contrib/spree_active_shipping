# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class PriorityOvernight < Spree::Calculator::Shipping::Fedex::PriorityOvernight
      end
    end
  end
end