module Spree
  class Calculator::Ups::Base < ActiveMerchant::Shipping::Base
    def carrier
      if Spree::ActiveShipping::Config[:shipper_number].nil?
        ActiveMerchant::Shipping::UPS.new(:login => Spree::ActiveShipping::Config[:ups_login],
                                          :password => Spree::ActiveShipping::Config[:ups_password],
                                          :key => Spree::ActiveShipping::Config[:ups_key],
                                          :test => Spree::ActiveShipping::Config[:test_mode])
      else
        ActiveMerchant::Shipping::UPS.new(:login => Spree::ActiveShipping::Config[:ups_login],
                                          :password => Spree::ActiveShipping::Config[:ups_password],
                                          :key => Spree::ActiveShipping::Config[:ups_key],
                                          :origin_account => Spree::ActiveShipping::Config[:shipper_number],
                                          :test => Spree::ActiveShipping::Config[:test_mode])
      end
    end
  end
end
