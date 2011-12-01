module Spree
  class Calculator::Fedex::ThreeDayFreightSaturdayDelivery < Calculator::Fedex::Base
    def self.description
      I18n.t("fedex.three_day_freight_saturday_delivery")
    end
  end
end
