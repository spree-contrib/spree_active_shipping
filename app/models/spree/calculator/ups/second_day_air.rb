module Spree
  class Calculator
    module Ups
      class SecondDayAir < Calculator::Ups::Base
        def self.description
          I18n.t("ups.second_day_air")
        end
      end
    end
  end
end
