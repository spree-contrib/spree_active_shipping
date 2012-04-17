module Spree
  class Calculator::Usps::Base < Spree::Calculator::ActiveShipping::Base
    def carrier
      carrier_details = {
        :login => Spree::ActiveShipping::Config[:usps_login],
        :test => Spree::ActiveShipping::Config[:test_mode]
      }

      ActiveMerchant::Shipping::Carriers::USPS.new(carrier_details)
    end
  end
end
