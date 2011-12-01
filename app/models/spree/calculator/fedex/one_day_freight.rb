module Spree
  class Calculator::Fedex::OneDayFreight < Calculator::Fedex::Base
    def self.description
      I18n.t("fedex.one_day_freight")
    end
  end
end
