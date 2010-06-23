class Calculator::Ups::Base < Calculator::ActiveShipping
  def carrier
    if Spree::ActiveShipping::Config[:shipper_number].nil?
      ActiveMerchant::Shipping::UPS.new(:login => Spree::ActiveShipping::Config[:ups_login],
                                        :password => Spree::ActiveShipping::Config[:ups_password],
                                        :key => Spree::ActiveShipping::Config[:ups_key])
    else
      ActiveMerchant::Shipping::UPS.new(:login => Spree::ActiveShipping::Config[:ups_login],
                                        :password => Spree::ActiveShipping::Config[:ups_password],
                                        :key => Spree::ActiveShipping::Config[:ups_key],
                                        :origin_account => Spree::ActiveShipping::Config[:shipper_number])
    end

  end
end