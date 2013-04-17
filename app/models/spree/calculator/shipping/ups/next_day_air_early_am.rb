module Spree
  module Calculator::Shipping
    module Ups
      class NextDayAirEarlyAm < Spree::Calculator::Shipping::Ups::Base
        def self.description
          I18n.t("ups.next_day_air_early_am")
        end
      end
    end
  end
end
