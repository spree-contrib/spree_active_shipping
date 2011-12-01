module Spree
  class Calculator::Ups::NextDayAirSaver < Calculator::Ups::Base
    def self.description
      I18n.t("ups.next_day_air_saver")
    end
  end
end
