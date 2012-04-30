module Spree
  class Calculator < ActiveRecord::Base
    module Usps
      class PriorityMailFlatRateEnvelope < Calculator::Usps::Base
        def self.description
          I18n.t("usps.priority_mail_flat_rate_envelope")
        end
      end
    end
  end
end
