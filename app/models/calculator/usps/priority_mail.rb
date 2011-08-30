class Calculator::Usps::PriorityMail < Calculator::Usps::Base
  def self.description
    I18n.t("usps.priority_mail")
  end
end
