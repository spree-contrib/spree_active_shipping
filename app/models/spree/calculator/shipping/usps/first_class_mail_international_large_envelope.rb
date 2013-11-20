module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassMailInternationalLargeEnvelope < Spree::Calculator::Shipping::Usps::Base
        WEIGHT_LIMITS = { "US" => 64 }

        def self.service_code
          14 #First-Class Mail® International Large Envelope
        end

        def self.description
          "USPS First-Class Mail International Large Envelope"
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


