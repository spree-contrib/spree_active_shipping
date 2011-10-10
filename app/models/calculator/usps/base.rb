class Calculator::Usps::Base < Calculator::ActiveShipping::Base
  def carrier
    ActiveMerchant::Shipping::USPS.new(:login => Spree::ActiveShipping::Config[:usps_login])
  end
end
