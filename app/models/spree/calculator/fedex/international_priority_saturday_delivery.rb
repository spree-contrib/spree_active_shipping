module Spree
  class Calculator
    module Fedex
      class InternationalPrioritySaturdayDelivery < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.intl_priority_saturday_delivery")
        end
      end
    end
  end
end
