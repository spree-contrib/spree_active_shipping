module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassMailInternationalLargeEnvelope < Spree::Calculator::Shipping::Usps::Base
        WEIGHT_LIMITS = { "US" => 64 }

        def self.geo_group
          :international
        end

        def self.service_code
          "#{SERVICE_CODE_PREFIX[geo_group]}:14" #First-Class Mail® International Large Envelope
        end

        def self.description
          I18n.t("usps.first_class_mail_international_large_envelope")
        end

        protected
        # weight limit in ounces or zero (if there is no limit)
        def max_weight_for_country(country)
          # if weight in ounces > 64, then First Class Mail International Large Envelope is not available for the order
          # https://www.usps.com/ship/first-class-package-international-service.htm?
          return WEIGHT_LIMITS[country.iso]
        end
      end
    end
  end
end


