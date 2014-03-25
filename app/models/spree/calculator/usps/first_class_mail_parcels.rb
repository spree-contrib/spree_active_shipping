# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  class Calculator < ActiveRecord::Base
    module Usps
      class FirstClassMailParcels < Spree::Calculator::Shipping::Usps::FirstClassMailParcels
      end
    end
  end
end