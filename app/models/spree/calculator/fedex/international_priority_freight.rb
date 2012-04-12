module Spree
  class Calculator
    class Fedex
      class InternationalPriorityFreight < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.intl_priority_freight")
        end
      end
    end
  end
end
