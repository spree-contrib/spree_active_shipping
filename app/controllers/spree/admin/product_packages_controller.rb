module Spree
  module Admin
    class ProductPackagesController < ResourceController
      belongs_to 'spree/product', :find_by => :permalink
      before_filter :load_data
      
      private
        def load_data
          @product = Product.where(:permalink => params[:product_id]).first
        end

    end
  end
end
