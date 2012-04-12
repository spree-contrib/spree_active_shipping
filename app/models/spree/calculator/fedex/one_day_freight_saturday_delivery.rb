module Spree
  class Calculator
    class Fedex
      class OneDayFreightSaturdayDelivery < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.one_day_freight_saturday_delivery")
        end
      end
    end
  end
end
