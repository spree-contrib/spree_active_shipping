module Spree
  module Calculator::Shipping
    module Fedex
      class TwoDayFreightSaturdayDelivery < Spree::Calculator::Shipping::Fedex::Base
        def self.description
          I18n.t("fedex.two_day_freight_saturday_delivery")
        end
      end
    end
  end
end
