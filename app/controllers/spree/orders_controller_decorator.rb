# handle shipping errors gracefully during order update
Spree::OrdersController.class_eval do

  rescue_from Spree::ShippingError, :with => :handle_shipping_error

  private
    def handle_shipping_error(e)
      flash[:error] = e.message
      redirect_back_or_default(root_path)
    end
end