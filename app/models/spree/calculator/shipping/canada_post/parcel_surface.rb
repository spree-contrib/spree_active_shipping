module Spree
  module Calculator::Shipping
    module CanadaPost
      class ParcelSurface < Spree::Calculator::Shipping::CanadaPost::Base
        def self.description
          I18n.t("canada_post.parcel_surface")
        end
      end
    end
  end
end
