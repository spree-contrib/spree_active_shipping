# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  class Calculator < ActiveRecord::Base
    module CanadaPost
      class SmallPacketsSurface < Spree::Calculator::Shipping::CanadaPost::SmallPacketsSurface
      end
    end
  end
end