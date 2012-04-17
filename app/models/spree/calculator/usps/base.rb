module Spree
  class Calculator::Usps::Base < ActiveMerchant::Shipping::Base
    def carrier
      ActiveMerchant::Shipping::USPS.new( :login => Spree::ActiveShipping::Config[:usps_login],
                                          :test => Spree::ActiveShipping::Config[:test_mode])
    end
  end
end
