module Spree
  class Calculator < ActiveRecord::Base
    module Fedex
      class ExpressSaver < Calculator::Fedex::Base
        def self.description
          I18n.t("fedex.express_saver")
        end
      end
    end
  end
end
