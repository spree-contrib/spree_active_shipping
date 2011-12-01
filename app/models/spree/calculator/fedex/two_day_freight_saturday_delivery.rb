module Spree
  class Calculator::Fedex::TwoDayFreightSaturdayDelivery < Calculator::Fedex::Base
    def self.description
      I18n.t("fedex.two_day_freight_saturday_delivery")
    end
  end
end
