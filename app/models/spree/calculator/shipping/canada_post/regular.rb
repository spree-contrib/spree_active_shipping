module Spree
  module Calculator::Shipping
    module CanadaPost
      class Regular < Spree::Calculator::Shipping::CanadaPost::Base
        def self.description
          I18n.t("canada_post.regular")
        end
      end
    end
  end
end
