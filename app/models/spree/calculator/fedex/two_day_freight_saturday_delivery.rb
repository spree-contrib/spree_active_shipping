module Spree
  class Calculator
    module Fedex
      class TwoDayFreightSaturdayDelivery < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.two_day_freight_saturday_delivery")
        end
      end
    end
  end
end
