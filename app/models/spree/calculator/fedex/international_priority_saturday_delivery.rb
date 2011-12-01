module Spree
  class Calculator::Fedex::InternationalPrioritySaturdayDelivery < Calculator::Fedex::Base
    def self.description
      I18n.t("fedex.intl_priority_saturday_delivery")
    end
  end
end
