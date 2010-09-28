# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class ActiveShippingExtension < Spree::Extension
  version "0.9.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/active_shipping"

  def activate
    [
      Calculator::Ups::Ground,
      Calculator::Ups::NextDayAir,
      Calculator::Ups::NextDayAirEarlyAm,
      Calculator::Ups::NextDayAirSaver,
      Calculator::Ups::Saver,
      Calculator::Ups::SecondDayAir,
      Calculator::Ups::ThreeDaySelect,
      Calculator::Ups::WorldwideExpedited,
      Calculator::Fedex::ExpressSaver,
      Calculator::Fedex::FirstOvernight,
      Calculator::Fedex::Ground,
      Calculator::Fedex::GroundHomeDelivery,
      Calculator::Fedex::InternationalEconomy,
      Calculator::Fedex::InternationalEconomyFreight,
      Calculator::Fedex::InternationalFirst,
      Calculator::Fedex::InternationalGround,
      Calculator::Fedex::InternationalPriority,
      Calculator::Fedex::InternationalPriorityFreight,
      Calculator::Fedex::InternationalPrioritySaturdayDelivery,
      Calculator::Fedex::OneDayFreight,
      Calculator::Fedex::OneDayFreightSaturdayDelivery,
      Calculator::Fedex::PriorityOvernight,
      Calculator::Fedex::PriorityOvernightSaturdayDelivery,
      Calculator::Fedex::StandardOvernight,
      Calculator::Fedex::ThreeDayFreight,
      Calculator::Fedex::ThreeDayFreightSaturdayDelivery,
      Calculator::Fedex::StandardOvernight,
      Calculator::Fedex::ThreeDayFreight,
      Calculator::Fedex::ThreeDayFreightSaturdayDelivery,
      Calculator::Fedex::TwoDay,
      Calculator::Fedex::TwoDayFreight,
      Calculator::Fedex::TwoDayFreightSaturdayDelivery,
      Calculator::Fedex::TwoDaySaturdayDelivery,
      Calculator::Usps::MediaMail,
      Calculator::Usps::ExpressMail,
      Calculator::Usps::ExpressMailInternational,
      Calculator::Usps::PriorityMail,
      Calculator::Usps::PriorityMailInternational,
      Calculator::Usps::PriorityMailSmallFlatRateBox,
      Calculator::Usps::PriorityMailRegularMediumFlatRateBoxes,
      Calculator::Usps::PriorityMailLargeFlatRateBox
    ].each(&:register)

    # handle shipping errors gracefully on admin ui
    Admin::ShipmentsController.class_eval do
      rescue_from Spree::ShippingError, :with => :handle_shipping_error

      private
        def handle_shipping_error(e)
          load_object
          flash.now[:error] = e.message
          render :action => "edit"
        end
    end

    #Only required until following active_shipping commit is merged (add negotiated rates).
    #http://github.com/BDQ/active_shipping/commit/2f2560d53aa7264383e5a35deb7264db60eb405a
    ActiveMerchant::Shipping::UPS.send(:include, Spree::ActiveShipping::UpsOverride)
  end
end
