class Calculator::Fedex::ThreeDayFreight < Calculator::Fedex::Base
  def self.description
    I18n.t("fedex.three_day_freight")
  end
end
