module Ups
  class Base < ActiveShippingCalculator  
    def carrier
      ActiveMerchant::Shipping::UPS.new(:login => Spree::ActiveShipping::Config[:ups_login], 
                                        :password => Spree::ActiveShipping::Config[:ups_password], 
                                        :key => Spree::ActiveShipping::Config[:ups_key])      
    end
  end
end