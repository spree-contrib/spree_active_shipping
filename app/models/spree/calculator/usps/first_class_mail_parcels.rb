require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module Usps
      class FirstClassMailParcels < Calculator::Usps::Base

        def self.description
          "USPS First-Class Mail Parcel"
        end
        
        def available?(order)
          multiplier = Spree::ActiveShipping::Config[:unit_multiplier]
          weight = order.line_items.inject(0) do |weight, line_item|
            weight + (line_item.variant.weight ? (line_item.quantity * line_item.variant.weight * multiplier) : 0)
          end
          #if weight in ounces > 13, then First Class Mail is not available for the order
          weight > 13 ? false : true
        end
      end
    end
  end
end
