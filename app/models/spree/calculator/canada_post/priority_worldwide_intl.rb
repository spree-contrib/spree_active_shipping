require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module CanadaPost
      class PriorityWorldwideIntl < Calculator::CanadaPost::Base
        def self.description
          I18n.t("canada_post.priority_worldwide_intl")
        end
      end
   end
  end
end

