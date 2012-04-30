module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class ThreeDayFreightSaturdayDelivery < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.three_day_freight_saturday_delivery")
        end
      end
    end
  end
end
