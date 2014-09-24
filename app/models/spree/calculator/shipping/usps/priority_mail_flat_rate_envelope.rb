module Spree
  module Calculator::Shipping
    module Usps
      class PriorityMailFlatRateEnvelope < Spree::Calculator::Shipping::Usps::Base
        def self.geo_group
          :domestic
        end

        def self.service_code
          "#{SERVICE_CODE_PREFIX[geo_group]}:16" #Priority Mail {0}™ Flat Rate Envelope
        end

        def self.description
          I18n.t("usps.priority_mail_flat_rate_envelope")
        end
      end
    end
  end
end
