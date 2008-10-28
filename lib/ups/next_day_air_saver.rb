require 'active_shipping'
include ActiveMerchant::Shipping

module Ups
  class NextDayAirSaver < Ups::Base
    def rate_name
      "UPS Next Day Air Saver"
    end
  end
end