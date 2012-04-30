module Spree
  class Calculator < ActiveRecord::Base
    module Usps
      class PriorityMailInternational < Calculator::Usps::Base
        def self.description
          I18n.t("usps.priority_mail_international")
        end
      end
    end
  end
end
