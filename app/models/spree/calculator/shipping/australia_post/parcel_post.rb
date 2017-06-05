module Spree
  module Calculator::Shipping
    module AustraliaPost
      class ParcelPost < Spree::Calculator::Shipping::AustraliaPost::Base
        def self.description
          "Parcel Post"
        end
      end
    end
  end
end
