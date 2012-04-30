module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class Base < Spree::Calculator::ActiveShipping::Base
        def carrier
          carrier_details = {
            :key => Spree::ActiveShipping::Config[:fedex_key],
            :password => Spree::ActiveShipping::Config[:fedex_password],
            :account => Spree::ActiveShipping::Config[:fedex_account],
            :login => Spree::ActiveShipping::Config[:fedex_login],
            :test => Spree::ActiveShipping::Config[:test_mode]
          }

          ActiveMerchant::Shipping::FedEx.new(carrier_details)
        end
      end
    end
  end
end
