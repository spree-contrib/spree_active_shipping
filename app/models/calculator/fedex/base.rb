class Calculator::Fedex::Base < Calculator::ActiveShipping
  def carrier
    ActiveMerchant::Shipping::FedEx.new(:key => Spree::ActiveShipping::Config[:fedex_key], 
                                        :password => Spree::ActiveShipping::Config[:fedex_password], 
                                        :account => Spree::ActiveShipping::Config[:fedex_account],
                                        :login => Spree::ActiveShipping::Config[:fedex_login])      
  end
end
