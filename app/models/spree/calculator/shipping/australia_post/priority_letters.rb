module Spree
  module Calculator::Shipping
    module AustraliaPost
      class PriorityLetters < Spree::Calculator::Shipping::AustraliaPost::Base
        def self.description
          "Priority Letters"
        end
      end
    end
  end
end
