require_dependency 'spree/calculator'

module Spree
  class Calculator < ActiveRecord::Base
    module CanadaPost
      class SmallPacketsAir < Calculator::CanadaPost::Base
        def self.description
          I18n.t("canada_post.small_packets_air")
        end
      end
   end
  end
end

