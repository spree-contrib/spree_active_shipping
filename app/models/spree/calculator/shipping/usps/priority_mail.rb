module Spree
  module Calculator::Shipping
    module Usps
      class PriorityMail < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t("usps.priority_mail")
        end
      end
    end
  end
end
