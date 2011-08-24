class Calculator::Usps::PriorityMail < Calculator::Usps::Base
  def self.description
    I18n.t("usps.priority_mail.description")
  end

  def self.service_name
    I18n.t("usps.priority_mail.service_name")
  end
end
