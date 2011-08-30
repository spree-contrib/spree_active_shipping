class Calculator::Usps::ExpressMailInternational < Calculator::Usps::Base
  def self.description
    I18n.t("usps.express_mail_intl")
  end
end
