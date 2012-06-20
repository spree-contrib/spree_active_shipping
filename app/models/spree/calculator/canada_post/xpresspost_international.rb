require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module CanadaPost
      class XpresspostInternational < Calculator::CanadaPost::Base
        def self.description
          I18n.t("canada_post.xpresspost_international")
        end
      end
   end
  end
end

