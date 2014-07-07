Spree::Admin::ProductsController.class_eval do
  def product_packages
    @product = Spree::Product.find_by_slug!(params[:id])
    @packages = @product.product_packages
    @product.product_packages.build
    
    respond_with(@object) do |format|
    format.html { render :layout => !request.xhr? }
      format.js { render :layout => false }
    end
  end
end
