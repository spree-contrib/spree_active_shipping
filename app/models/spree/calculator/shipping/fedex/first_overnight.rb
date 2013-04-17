require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Fedex
      class FirstOvernight < Spree::Calculator::Shipping::Fedex::Base
        def self.description
          I18n.t("fedex.first_overnight")
        end
      end
    end
  end
end
