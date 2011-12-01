module Spree
  class Calculator::Fedex::PriorityOvernight < Calculator::Fedex::Base
    def self.description
      I18n.t("fedex.priority_overnight")
    end
  end
end
