module Spree
  module Admin
    class ProductPackagesController < ResourceController
      belongs_to 'spree/product', :find_by => :permalink
      before_filter :find_packages
      before_filter :setup_package, :only => [:index]

      private
        def find_packages
          @packages = @product.product_packages
        end

        def setup_package
          @product.product_packages.build
        end
    end
  end
end
