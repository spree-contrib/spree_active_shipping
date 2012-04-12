module Spree
  class Calculator
    class Fedex
      class InternationalPriority < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.intl_priority")
        end
      end
    end
  end
end
