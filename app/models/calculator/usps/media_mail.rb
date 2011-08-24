class Calculator::Usps::MediaMail < Calculator::Usps::Base
  def self.description
    I18n.t("usps.media_mail.description")
  end

  def self.service_name
    I18n.t("usps.media_mail.service_name")
  end
end
