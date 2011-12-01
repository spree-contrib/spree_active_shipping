module Spree
  class Calculator::Fedex::ExpressSaver < Calculator::Fedex::Base
    def self.description
      I18n.t("fedex.express_saver")
    end
  end
end
