module Spree
  module Calculator::Shipping
    module Ups
      class NextDayAirSaver < Spree::Calculator::Shipping::Ups::Base
        def self.description
          I18n.t("ups.next_day_air_saver")
        end
      end
    end
  end
end
