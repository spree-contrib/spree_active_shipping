module Spree
  class Calculator::Ups::Ground < Calculator::Ups::Base
    def self.description
      I18n.t("ups.ground")
    end
  end
end
