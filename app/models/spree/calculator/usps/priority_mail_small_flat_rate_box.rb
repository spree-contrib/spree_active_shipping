require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Usps
      class PriorityMailSmallFlatRateBox < Calculator::Usps::Base
        def self.service_code
          28 #Priority Mail {0}™ Small Flat Rate Box
        end

        def self.description
          I18n.t("usps.priority_mail_small_flat_rate_box")
        end
      end
    end
  end
end
