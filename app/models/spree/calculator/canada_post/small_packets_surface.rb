require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module CanadaPost
      class SmallPacketsSurface < Calculator::CanadaPost::Base
        def self.description
          I18n.t("canada_post.small_packets_surface")
        end
      end
   end
  end
end

