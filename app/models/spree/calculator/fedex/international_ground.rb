module Spree
  class Calculator
    class Fedex
      class InternationalGround < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.intl_ground")
        end
      end
    end
  end
end
