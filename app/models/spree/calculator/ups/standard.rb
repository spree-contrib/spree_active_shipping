module Spree
  class Calculator::Ups::Standard < Calculator::Ups::Base
    def self.description
      I18n.t("ups.standard")
    end
  end
end
