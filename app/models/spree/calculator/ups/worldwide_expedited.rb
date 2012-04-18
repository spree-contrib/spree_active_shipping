module Spree
  class Calculator
    module Ups
      class WorldwideExpedited < Calculator::Ups::Base
        def self.description
          I18n.t("ups.worldwide_expedited")
        end
      end
    end
  end
end
