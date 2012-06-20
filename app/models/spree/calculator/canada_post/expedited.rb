module Spree
  class Calculator < ActiveRecord::Base
    module CanadaPost
      class Expedited < Calculator::CanadaPost::Base
        def self.description
          "Canada Post Expedited"
          #I18n.t("canada_post.priority")
        end
      end
   end
  end
end
