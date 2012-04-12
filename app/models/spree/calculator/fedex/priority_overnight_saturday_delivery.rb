module Spree
  class Calculator
    class Fedex
      class PriorityOvernightSaturdayDelivery < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.priority_overnight_saturday_delivery")
        end
      end
    end
  end
end
