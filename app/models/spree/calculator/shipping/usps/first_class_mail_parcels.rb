module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassMailParcels < Spree::Calculator::Shipping::Usps::Base

        def self.service_code
          0 #First-Class Mail® Parcel
        end

        def self.description
          "USPS First-Class Mail Parcel"
        end

        def available?(package)
          multiplier = Spree::ActiveShipping::Config[:unit_multiplier]
          weight = package.order.line_items.inject(0) do |weight, line_item|
            weight + (line_item.variant.weight ? (line_item.quantity * line_item.variant.weight * multiplier) : 0)
          end
          #if weight in ounces > 13, then First Class Mail is not available for the order
          weight > 13 ? false : true
        end
      end
    end
  end
end
