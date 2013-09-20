module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassMailInternationalLargeEnvelope < Spree::Calculator::Shipping::Usps::Base

        def self.service_code
          14 #First-Class Mail® International Large Envelope
        end

        def self.description
          "USPS First-Class Mail International Large Envelope"
        end

        def available?(package)
          multiplier = Spree::ActiveShipping::Config[:unit_multiplier]
          weight = package.order.line_items.inject(0) do |weight, line_item|
            weight + (line_item.variant.weight ? (line_item.quantity * line_item.variant.weight * multiplier) : 0)
          end
          #if weight in ounces > 64, then First Class Mail International Large Envelope is not available for the order
          weight > 64 ? false : true
        end
      end
    end
  end
end


