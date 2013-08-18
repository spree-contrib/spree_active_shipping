module Spree
  module Calculator::Shipping
    module Usps
      class ExpressMail < Spree::Calculator::Shipping::Usps::Base
        def self.service_code
          3 #Priority Mail Express {0}™
        end

        def self.description
          I18n.t("usps.express_mail")
        end
      end
    end
  end
end
