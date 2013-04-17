module Spree
  module Calculator::Shipping
    module CanadaPost
      class SmallPacketsAir < Spree::Calculator::Shipping::CanadaPost::Base
        def self.description
          I18n.t("canada_post.small_packets_air")
        end
      end
    end
  end
end
