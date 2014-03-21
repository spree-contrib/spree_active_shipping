# Defined for backwards compatibility with 1-3-stable
# See spree/spree#4479

module Spree
  module Calculator
    module Usps
      class MediaMail < Spree::Calculator::Shipping::Usps::MediaMail
      end
    end
  end
end