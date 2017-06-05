module Spree
  module Calculator::Shipping
    module AustraliaPost
      class CourierPost < Spree::Calculator::Shipping::AustraliaPost::Base
        def self.description
          "Courier Post"
        end
      end
    end
  end
end
