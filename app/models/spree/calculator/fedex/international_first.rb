require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class InternationalFirst < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.intl_first")
        end
      end
    end
  end
end
