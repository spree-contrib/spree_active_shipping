module Spree
  module Calculator::Shipping
    module Usps
      class Base < Spree::Calculator::Shipping::ActiveShipping::Base
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
          1120	# 70 lbs
        end
      end
    end
  end
end
