class Calculator::Usps::PriorityMailLargeFlatRateBox < Calculator::Usps::Base
  def self.description
    I18n.t("usps.priority_mail_large_flat_rate.description")
  end

  def self.service_name
    I18n.t("usps.priority_mail_large_flat_rate.service_name")
  end
end
