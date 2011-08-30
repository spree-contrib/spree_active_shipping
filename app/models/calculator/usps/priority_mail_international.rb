class Calculator::Usps::PriorityMailInternational < Calculator::Usps::Base
  def self.description
    I18n.t("usps.priority_mail_international")
  end
end
