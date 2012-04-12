module Spree
  class Calculator
    class Fedex
      class OneDayFreight < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.one_day_freight")
        end
      end
    end
  end
end
