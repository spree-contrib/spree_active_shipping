module Spree
  class Calculator::Fedex::Saver < Calculator::Fedex::Base
    def self.description
      I18n.t("fedex.saver")
    end
  end
end
