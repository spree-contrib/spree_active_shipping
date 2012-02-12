module Spree
  class Calculator::Usps::Base < Calculator::ActiveShipping::Base
    def carrier
      ActiveMerchant::Shipping::USPS.new( :login => Spree::ActiveShipping::Config[:usps_login],
                                          :test => Spree::ActiveShipping::Config[:test_mode])
    end
  end
end
