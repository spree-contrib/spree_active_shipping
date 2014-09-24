module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassMailParcel < Spree::Calculator::Shipping::Usps::Base
        WEIGHT_LIMITS = { "US" => 13 }

        def self.geo_group
          :domestic
        end

        def self.service_code
          "#{SERVICE_CODE_PREFIX[geo_group]}:0" #First-Class Mail® Parcel
        end

        def self.description
          I18n.t("usps.first_class_mail_parcel")
        end

        protected
        def max_weight_for_country(country)
          #if weight in ounces > 13, then First Class Mail is not available for the order
          # https://www.usps.com/ship/first-class-international.htm
          return WEIGHT_LIMITS[country.iso]
        end
      end
    end
  end
end
