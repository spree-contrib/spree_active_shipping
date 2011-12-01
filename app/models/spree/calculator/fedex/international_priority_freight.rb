module Spree
  class Calculator::Fedex::InternationalPriorityFreight < Calculator::Fedex::Base
    def self.description
      I18n.t("fedex.intl_priority_freight")
    end
  end
end
