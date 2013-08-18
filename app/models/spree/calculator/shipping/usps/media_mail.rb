module Spree
  module Calculator::Shipping
    module Usps
      class MediaMail < Spree::Calculator::Shipping::Usps::Base
        def self.service_code
          6 #Media Mail®
        end

        def self.description
          I18n.t("usps.media_mail")
        end
      end
    end
  end
end
