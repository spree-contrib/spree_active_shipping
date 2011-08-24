class Calculator::Usps::ExpressMail < Calculator::Usps::Base
  def self.description
    I18n.t("usps.express_mail.description")
  end

  def self.service_name
    I18n.t("usps.express_mail.service_name")
  end
end
