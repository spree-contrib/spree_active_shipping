module Spree
  class Calculator::Fedex::TwoDaySaturdayDelivery < Calculator::Fedex::Base
    def self.description
      I18n.t("fedex.two_day_saturday_delivery")
    end
  end
end
