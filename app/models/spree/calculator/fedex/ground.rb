require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class Ground < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.ground")
        end
      end
    end
  end
end
