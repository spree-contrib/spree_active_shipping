module Spree
  module Calculator::Shipping
    module Usps
      class ExpressMail < Spree::Calculator::Shipping::Usps::Base
        def self.geo_group
          :domestic
        end

        def self.service_code
          "#{SERVICE_CODE_PREFIX[geo_group]}:3" #Priority Mail Express {0}™
        end

        def self.description
          I18n.t("usps.express_mail")
        end
      end
    end
  end
end
