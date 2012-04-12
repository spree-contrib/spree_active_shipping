module Spree
  class Calculator
    class Fedex
      class InternationalEconomy < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.intl_economy")
        end
      end
    end
  end
end
