module Spree
  class Calculator
    class Fedex
      class InternationalEconomyFreight < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.intl_economy_freight")
        end
      end
    end
  end
end
