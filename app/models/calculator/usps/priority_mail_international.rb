class Calculator::Usps::PriorityMailInternational < Calculator::Usps::Base
  def self.description
    I18n.t("usps.priority_mail_intl.description")
  end

  def self.service_name
    I18n.t("usps.priority_mail_intl.service_name")
  end
end
