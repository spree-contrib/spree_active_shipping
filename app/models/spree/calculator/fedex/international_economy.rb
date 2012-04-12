module Spree
  class Calculator
    module Fedex
      class InternationalEconomy < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.intl_economy")
        end
      end
    end
  end
end
