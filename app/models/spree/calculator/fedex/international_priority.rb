# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class InternationalPriority < Spree::Calculator::Shipping::Fedex::InternationalPriority
      end
    end
  end
end