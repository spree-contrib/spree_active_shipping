module Spree
  class Calculator < ActiveRecord::Base
    module CanadaPost
      class Regular < Calculator::CanadaPost::Base
        def self.description
          "Canada Post Regular"
          #I18n.t("canada_post.regular")
        end
      end
   end
  end
end
