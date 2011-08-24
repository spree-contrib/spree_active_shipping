class Calculator::Fedex::StandardOvernight < Calculator::Fedex::Base
  def self.description
    I18n.t("fedex.standard_overnight")
  end
end
