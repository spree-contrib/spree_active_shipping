class Calculator::Usps::ExpressMail < Calculator::Usps::Base
  def self.description
    I18n.t("usps.express_mail")
  end
end
