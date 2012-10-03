require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Usps
      class PriorityMailInternationalMediumFlatRateBox < Calculator::Usps::Base
        def self.description
          I18n.t("usps.priority_mail_international_medium_flat_rate_box")
        end
        
        protected
        # weight limit in ounces http://pe.usps.com/text/imm/immc2_011.htm
        def max_weight_for_country(country)
          20*Spree::ActiveShipping::Config[:unit_multiplier]
        end
      end
    end
  end
end
