module Spree
  class Calculator
    class Fedex
      class Ground < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.ground")
        end
      end
    end
  end
end
