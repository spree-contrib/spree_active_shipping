module Spree
  class Calculator
    module Usps
      class ExpressMailInternational < Calculator::Usps::Base
        def self.description
          I18n.t("usps.express_mail_intl")
        end
      end
    end
  end
end
