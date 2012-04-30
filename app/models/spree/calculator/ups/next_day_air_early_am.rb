module Spree
  class Calculator < ActiveRecord::Base
    module Ups
      class NextDayAirEarlyAm < Calculator::Ups::Base
        def self.description
          I18n.t("ups.next_day_air_early_am")
        end
      end
    end
  end
end
