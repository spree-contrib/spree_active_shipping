class Calculator::Usps::Base < Calculator::ActiveShipping
  def carrier
    ActiveMerchant::Shipping::USPS.new(:login => Spree::ActiveShipping::Config[:usps_login])
  end
end
