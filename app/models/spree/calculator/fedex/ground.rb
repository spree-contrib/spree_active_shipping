module Spree
  class Calculator::Fedex::Ground < Calculator::Fedex::Base
    def self.description
      I18n.t("fedex.ground")
    end
  end
end
