require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class InternationalPriorityFreight < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.intl_priority_freight")
        end
      end
    end
  end
end
