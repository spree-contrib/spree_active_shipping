module Spree
  class Calculator
    module Fedex
      class ThreeDayFreight < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.three_day_freight")
        end
      end
    end
  end
end
