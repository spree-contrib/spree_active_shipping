require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module AustraliaPost
      class Base < Spree::Calculator::Shipping::ActiveShipping::Base
        def carrier
          australia_post_options = {
            api_key: Spree::ActiveShipping::Config[:australia_post_login],
          }
          ::ActiveShipping::AustraliaPost.new(australia_post_options)
        end
      end
    end
  end
end
