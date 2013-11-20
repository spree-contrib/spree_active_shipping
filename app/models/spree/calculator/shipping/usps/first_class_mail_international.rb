module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassMailInternational < Spree::Calculator::Shipping::Usps::Base
        WEIGHT_LIMITS = { "US" => 3.5 }

        def self.service_code
          13 #First-Class Mail® International Letter
        end

        def self.description
          "USPS First-Class Mail International Letter"
        end


        protected
        def max_weight_for_country(country)
          # if weight in ounces > 3.5, then First Class Mail International is not available for the order
          # https://www.usps.com/ship/first-class-international.htm
          return WEIGHT_LIMITS[country.iso]
        end
      end
    end
  end
end


