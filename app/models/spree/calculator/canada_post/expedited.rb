require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module CanadaPost
      class Expedited < Calculator::CanadaPost::Base
        def self.description
          I18n.t("canada_post.expedited")
        end
      end
   end
  end
end
