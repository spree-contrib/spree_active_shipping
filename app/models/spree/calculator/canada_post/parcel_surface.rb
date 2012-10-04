require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module CanadaPost
      class ParcelSurface < Calculator::CanadaPost::Base
        def self.description
          I18n.t("canada_post.parcel_surface")
        end
      end
   end
  end
end

