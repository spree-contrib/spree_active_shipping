module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassMailParcels < Spree::Calculator::Shipping::Usps::Base
        WEIGHT_LIMITS = { "US" => 13 }

        def self.service_code
          0 #First-Class Mail® Parcel
        end

        def self.description
          "USPS First-Class Mail Parcel"
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
