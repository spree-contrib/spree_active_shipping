require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class PriorityOvernightSaturdayDelivery < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.priority_overnight_saturday_delivery")
        end
      end
    end
  end
end
