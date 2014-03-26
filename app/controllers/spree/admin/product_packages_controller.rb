module Spree
  module Admin
    class ProductPackagesController < ResourceController
      belongs_to 'spree/product', :find_by => :slug
      before_filter :load_data

      private
        def load_data
          @product = Product.friendly.find(params[:product_id])
        end

        def permitted_product_package_attributes
          [:length, :width, :height, :weight]
        end
    end
  end
end
