require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module CanadaPost
      class Base < Spree::Calculator::Shipping::ActiveShipping::Base
        def carrier
          canada_post_options = {
            :login  => Spree::ActiveShipping::Config[:canada_post_login],
            :french => (I18n.locale.to_sym == :fr)
          }
          ActiveMerchant::Shipping::CanadaPost.new(canada_post_options)
        end
      end
    end
  end
end
