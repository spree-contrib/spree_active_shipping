module Spree
  class Calculator
    module Usps
      class PriorityMailMediumFlatRateBox < Calculator::Usps::Base
        def self.description
          I18n.t("usps.priority_mail_medium_flat_rate_box")
        end
      end
    end
  end
end
