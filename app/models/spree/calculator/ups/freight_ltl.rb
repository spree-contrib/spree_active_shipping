require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Ups
      class FreightLtl < Calculator::Ups::Base
        def self.description
          "UPS Freight LTL"
        end
      end
    end
  end
end

