require 'active_shipping'
include ActiveMerchant::Shipping

module Ups
  class ThreeDaySelect < Ups::Base
    def rate_name
      "UPS Three-Day Select"
    end
  end
end