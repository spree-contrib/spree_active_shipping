module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class FirstOvernight < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.first_overnight")
        end
      end
    end
  end
end
