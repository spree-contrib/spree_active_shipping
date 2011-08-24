class Calculator::Usps::PriorityMailRegularMediumFlatRateBoxes < Calculator::Usps::Base
  def self.description
    I18n.t("usps.priority_mail_regular_medium_flat_rate_boxes.description")
  end

  def self.service_name
    I18n.t("usps.priority_mail_regular_medium_flat_rate_boxes.service_name")
  end
end
