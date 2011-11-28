# handle shipping errors gracefully during checkout
CheckoutController.class_eval do
  
  rescue_from Spree::ShippingError, :with => :handle_shipping_error

  private
    def handle_shipping_error(e)
      flash[:error] = e.message
      
      ####################
      # In the case that the following error is thrown => Shipping Error: The postal code 82001 is invalid for DC United States.
      # Perform the following
      # - compare ship_address and bill_address to determine if they are the same
      # - strip zipcode and state from ship_address (and also bill_address if needed) without triggering validations
      # - continue with redirect
      ####################
      if e.message.include? 'postal code'
        ship_address = current_order.ship_address
        bill_address = current_order.bill_address
        if ship_address.zipcode == bill_address.zipcode and ship_address.state_id == bill_address.state_id
          bill_address.update_attribute(:zipcode, nil)
          bill_address.update_attribute(:state, nil)
        end
        ship_address.update_attribute(:zipcode, nil)
        ship_address.update_attribute(:state, nil)
      end
      redirect_to checkout_state_path(:address)
    end
end
