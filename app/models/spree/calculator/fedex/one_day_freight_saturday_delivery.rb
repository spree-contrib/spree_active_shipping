module Spree
  class Calculator::Fedex::OneDayFreightSaturdayDelivery < Calculator::Fedex::Base
    def self.description
      I18n.t("fedex.one_day_freight_saturday_delivery")
    end
  end
end
