module Spree
  class Calculator::Fedex::InternationalPriority < Calculator::Fedex::Base
    def self.description
      I18n.t("fedex.intl_priority")
    end
  end
end
