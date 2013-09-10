require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Ups
      class FreightLtl < Calculator::Ups::Base
        def self.description
          I18n.t("ups.freight_ltl")
        end
      end
    end
  end
end

