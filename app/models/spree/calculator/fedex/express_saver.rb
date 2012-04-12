module Spree
  class Calculator
    class Fedex
      class ExpressSaver < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.express_saver")
        end
      end
    end
  end
end
