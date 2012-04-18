module Spree
  class Calculator
    module Usps
      class MediaMail < Calculator::Usps::Base
        def self.description
          I18n.t("usps.media_mail")
        end
      end
    end
  end
end
