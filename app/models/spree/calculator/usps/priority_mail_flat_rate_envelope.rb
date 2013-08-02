require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Usps
      class PriorityMailFlatRateEnvelope < Calculator::Usps::Base
        def self.service_code
          16 #Priority Mail {0}™ Flat Rate Envelope
        end

        def self.description
          I18n.t("usps.priority_mail_flat_rate_envelope")
        end
      end
    end
  end
end
