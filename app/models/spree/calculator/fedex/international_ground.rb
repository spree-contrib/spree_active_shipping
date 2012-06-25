require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class InternationalGround < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.intl_ground")
        end
      end
    end
  end
end
