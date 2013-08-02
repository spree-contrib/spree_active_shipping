require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Usps
      class PriorityMailMediumFlatRateBox < Calculator::Usps::Base
        def self.service_code
          17 #Priority Mail {0}™ Medium Flat Rate Box
        end

        def self.description
          I18n.t("usps.priority_mail_medium_flat_rate_box")
        end
      end
    end
  end
end
