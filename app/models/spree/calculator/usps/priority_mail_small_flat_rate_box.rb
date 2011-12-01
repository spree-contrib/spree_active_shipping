module Spree
  class Calculator::Usps::PriorityMailSmallFlatRateBox < Calculator::Usps::Base
    def self.description
      I18n.t("usps.priority_mail_small_flat_rate_box")
    end
  end
end
