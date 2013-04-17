module Spree
  module Calculator::Shipping
    module Ups
      class Saver < Spree::Calculator::Shipping::Ups::Base
        def self.description
          I18n.t("ups.saver")
        end
      end
    end
  end
end
