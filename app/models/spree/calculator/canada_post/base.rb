require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module CanadaPost
      class Base < Spree::Calculator::ActiveShipping::Base
        def carrier
          carrier_details = {
            :login => Spree::ActiveShipping::Config[:canada_post_login],
          }
          ActiveMerchant::Shipping::CanadaPost.new(carrier_details)
        end
      end
    end
  end
end
