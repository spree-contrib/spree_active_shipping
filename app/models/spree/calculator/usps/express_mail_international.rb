require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Usps
      class ExpressMailInternational < Calculator::Usps::Base
        def self.description
          I18n.t("usps.express_mail_intl")
        end
      end
    end
  end
end
