require 'active_shipping'
include ActiveMerchant::Shipping

module Ups
  class NextDayAirEarlyAM < Ups::Base
    def rate_name
      "UPS Next Day Air Early A.M."
    end
  end
end