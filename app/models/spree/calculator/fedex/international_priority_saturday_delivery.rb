module Spree
  class Calculator
    class Fedex
      class InternationalPrioritySaturdayDelivery < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.intl_priority_saturday_delivery")
        end
      end
    end
  end
end
