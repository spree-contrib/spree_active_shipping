# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  module Calculator
    module CanadaPost
      class SmallPacketsAir < Spree::Calculator::Shipping::CanadaPost::SmallPacketsAir
      end
    end
  end
end