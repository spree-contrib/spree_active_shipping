# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  class Calculator < ActiveRecord::Base
    module Ups
      class NextDayEarlyAm < Spree::Calculator::Shipping::Ups::NextDayEarlyAm
      end
    end
  end
end