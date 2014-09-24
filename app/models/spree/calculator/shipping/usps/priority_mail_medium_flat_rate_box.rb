module Spree
  module Calculator::Shipping
    module Usps
      class PriorityMailMediumFlatRateBox < Spree::Calculator::Shipping::Usps::Base
        def self.geo_group
          :domestic
        end

        def self.service_code
          "#{SERVICE_CODE_PREFIX[geo_group]}:17" #Priority Mail {0}™ Medium Flat Rate Box
        end

        def self.description
          I18n.t("usps.priority_mail_medium_flat_rate_box")
        end
      end
    end
  end
end
