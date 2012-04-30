module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class TwoDayFreight < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.two_day_freight")
        end
      end
    end
  end
end
