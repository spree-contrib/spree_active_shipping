require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Usps
      class Base < Spree::Calculator::ActiveShipping::Base
        def carrier
          carrier_details = {
            :login => Spree::ActiveShipping::Config[:usps_login],
            :test => Spree::ActiveShipping::Config[:test_mode]
          }

          ActiveMerchant::Shipping::USPS.new(carrier_details)
        end
        
        protected
        # weight limit in ounces or zero (if there is no limit)
        def max_weight_for_country(country)
          70*Spree::ActiveShipping::Config[:unit_multiplier]
        end
      end
    end
  end
end
