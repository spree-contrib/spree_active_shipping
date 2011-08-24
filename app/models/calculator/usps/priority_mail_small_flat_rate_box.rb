class Calculator::Usps::PriorityMailSmallFlatRateBox < Calculator::Usps::Base
  def self.description
    I18n.t("usps.priority_mail_small_flat_rate_box.description")
  end

  def self.service_name
    I18n.t("usps.priority_mail_small_flat_rate_box.service_name")
  end
end
