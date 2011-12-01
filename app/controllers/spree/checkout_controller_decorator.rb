# handle shipping errors gracefully during checkout
Spree::CheckoutController.class_eval do

  rescue_from Spree::ShippingError, :with => :handle_shipping_error

  private
    def handle_shipping_error(e)
      flash[:error] = e.message
      redirect_to checkout_state_path(:address)
    end
end
