module Spree
  class Calculator
    module Fedex
      class InternationalPriority < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.intl_priority")
        end
      end
    end
  end
end
