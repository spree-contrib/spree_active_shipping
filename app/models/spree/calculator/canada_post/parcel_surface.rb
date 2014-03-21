# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  module Calculator
    module CanadaPost
      class ParcelSurface < Spree::Calculator::Shipping::CanadaPost::ParcelSurface
      end
    end
  end
end