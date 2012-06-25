require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Ups
      class NextDayAir < Calculator::Ups::Base
        def self.description
          I18n.t("ups.next_day_air")
        end
      end
    end
  end
end
