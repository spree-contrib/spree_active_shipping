# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class Saver < Spree::Calculator::Shipping::Fedex::Saver
      end
    end
  end
end