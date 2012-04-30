module Spree
  class Calculator < ActiveRecord::Base
    module Ups
      class Saver < Calculator::Ups::Base
        def self.description
          I18n.t("ups.saver")
        end
      end
    end
  end
end
