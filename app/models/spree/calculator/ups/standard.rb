module Spree
  class Calculator
    module Ups
      class Standard < Calculator::Ups::Base
        def self.description
          I18n.t("ups.standard")
        end
      end
    end
  end
end
