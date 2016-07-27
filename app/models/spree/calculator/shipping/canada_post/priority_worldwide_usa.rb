module Spree
  module Calculator::Shipping
    module CanadaPost
      class PriorityWorldwideUsa < Spree::Calculator::Shipping::CanadaPost::Base
        def self.description
          I18n.t("canada_post.priority_worldwide_usa")
        end
      end
    end
  end
end
