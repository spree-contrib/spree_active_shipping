module Spree
  module Admin
    class ProductPackagesController < ResourceController
      belongs_to 'spree/product', :find_by => :permalink
      before_filter :find_packages
      before_filter :setup_package, :only => [:index]

      protected
        def permitted_resource_params
          params.require(:product_package).permit(permitted_product_package_attributes)
        end

      private
        def find_packages
          @packages = @product.product_packages
        end

        def setup_package
          @product.product_packages.build
        end

        def permitted_product_package_attributes
          [:length, :width, :height, :weight]
        end
    end
  end
end
