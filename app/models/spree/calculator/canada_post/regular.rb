require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module CanadaPost
      class Regular < Calculator::CanadaPost::Base
        def self.description
          I18n.t("canada_post.regular")
        end
      end
   end
  end
end
