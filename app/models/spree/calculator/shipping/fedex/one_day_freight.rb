require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Fedex
      class OneDayFreight < Spree::Calculator::Shipping::Fedex::Base
        def self.description
          I18n.t("fedex.one_day_freight")
        end
      end
    end
  end
end
