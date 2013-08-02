require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Usps
      class PriorityMail < Calculator::Usps::Base
        def self.service_code
          1 #Priority Mail {0}™
        end

        def self.description
          I18n.t("usps.priority_mail")
        end
      end
    end
  end
end
