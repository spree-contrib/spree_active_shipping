module Spree
  class Calculator
    class Fedex
      class Saver < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.saver")
        end
      end
    end
  end
end
