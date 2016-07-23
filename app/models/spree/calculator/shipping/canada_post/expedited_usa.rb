module Spree
  module Calculator::Shipping
    module CanadaPost
      class ExpeditedUsa < Spree::Calculator::Shipping::CanadaPost::Base
        def self.description
          I18n.t("canada_post.expedited_usa")
        end
      end
    end
  end
end
