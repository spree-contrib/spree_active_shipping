# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  class Calculator < ActiveRecord::Base
    module Ups
      class NextDayAir < Spree::Calculator::Shipping::Ups::NextDayAir
      end
    end
  end
end