require 'active_shipping'
include ActiveMerchant::Shipping

module Ups
  class SecondDayAir < Ups::Base
    def rate_name
      "UPS Second Day Air"
    end
  end
end