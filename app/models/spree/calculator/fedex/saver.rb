module Spree
  class Calculator
    module Fedex
      class Saver < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.saver")
        end
      end
    end
  end
end
