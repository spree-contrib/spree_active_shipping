module Spree
  class Calculator::Usps::MediaMail < Calculator::Usps::Base
    def self.description
      I18n.t("usps.media_mail")
    end
  end
end
