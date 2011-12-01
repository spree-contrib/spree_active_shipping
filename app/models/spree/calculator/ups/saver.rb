module Spree
  class Calculator::Ups::Saver < Calculator::Ups::Base
    def self.description
      I18n.t("ups.saver")
    end
  end
end
