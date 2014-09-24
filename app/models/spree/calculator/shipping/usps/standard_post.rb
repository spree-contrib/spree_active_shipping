module Spree
  module Calculator::Shipping
    module Usps
      class StandardPost < Spree::Calculator::Shipping::Usps::Base
        def self.geo_group
          :domestic
        end

        def self.service_code
          "#{SERVICE_CODE_PREFIX[geo_group]}:4" #Standard Post
        end

        def self.description
          I18n.t("usps.standard_post")
        end
      end
    end
  end
end
