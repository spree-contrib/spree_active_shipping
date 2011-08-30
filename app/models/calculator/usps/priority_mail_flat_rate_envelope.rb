class Calculator::Usps::PriorityMailFlatRateEnvelope < Calculator::Usps::Base
  def self.description
    I18n.t("usps.priority_mail_flat_rate_envelope.description")
  end

  def self.service_name
    I18n.t("usps.priority_mail_flat_rate_envelope.service_name")
  end
end
