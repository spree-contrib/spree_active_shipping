module Spree
  class Calculator
    module Ups
      class NextDayAir < Calculator::Ups::Base
        def self.description
          I18n.t("ups.next_day_air")
        end
      end
    end
  end
end
