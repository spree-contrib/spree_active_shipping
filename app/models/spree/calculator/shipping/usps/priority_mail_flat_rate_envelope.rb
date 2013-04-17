module Spree
  module Calculator::Shipping
    module Usps
      class PriorityMailFlatRateEnvelope < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t("usps.priority_mail_flat_rate_envelope")
        end
      end
    end
  end
end
