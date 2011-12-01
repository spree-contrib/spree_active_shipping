module Spree
  class Calculator::Fedex::InternationalGround < Calculator::Fedex::Base
    def self.description
      I18n.t("fedex.intl_ground")
    end
  end
end
