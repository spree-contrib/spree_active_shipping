module Spree
  module Calculator::Shipping
    module Ups
      class Standard < Spree::Calculator::Shipping::Ups::Base
        def self.description
          I18n.t("ups.standard")
        end
      end
    end
  end
end
