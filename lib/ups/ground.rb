require 'active_shipping'
include ActiveMerchant::Shipping

module Ups
  class Ground < Ups::Base
    def rate_name
      "UPS Ground"
    end
  end
end