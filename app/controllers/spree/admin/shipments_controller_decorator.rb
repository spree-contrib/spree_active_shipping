# handle shipping errors gracefully on admin ui
Spree::Admin::ShipmentsController.class_eval do
  rescue_from Spree::ShippingError, :with => :handle_shipping_error

  private
    def handle_shipping_error(e)
      load_object
      flash.now[:error] = e.message
      render :action => "edit"
    end
end
