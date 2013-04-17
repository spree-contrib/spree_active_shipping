module Spree
  module Calculator::Shipping
    module CanadaPost
      class Expedited < Spree::Calculator::Shipping::CanadaPost::Base
        def self.description
          I18n.t("canada_post.expedited")
        end
      end
   end
  end
end
