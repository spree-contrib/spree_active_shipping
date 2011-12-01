module Spree
  class Calculator::Ups::WorldwideExpedited < Calculator::Ups::Base
    def self.description
      I18n.t("ups.worldwide_expedited")
    end
  end
end
