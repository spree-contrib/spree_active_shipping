module Spree
  class Calculator
    module Ups
      class Ground < Calculator::Ups::Base
        def self.description
          I18n.t("ups.ground")
        end
      end
    end
  end
end
