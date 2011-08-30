require 'spree_core'
require 'active_shipping'

module ActiveShippingExtension
  class Engine < Rails::Engine
    
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/models/calculator/active_shipping.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      Dir.glob(File.join(File.dirname(__FILE__), "../app/models/calculator/usps/base.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      Dir.glob(File.join(File.dirname(__FILE__), "../app/models/calculator/**/*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      
      Dir.glob(File.join(File.dirname(__FILE__), "spree/**/*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      
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
        Calculator::Usps::PriorityMailLargeFlatRateBox,
        Calculator::Usps::PriorityMailFlatRateEnvelope,
      ].each(&:register)
      
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      
      #Only required until following active_shipping commit is merged (add negotiated rates).
      #http://github.com/BDQ/active_shipping/commit/2f2560d53aa7264383e5a35deb7264db60eb405a
      ActiveMerchant::Shipping::UPS.send(:include, Spree::ActiveShipping::UpsOverride)
      
    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare &method(:activate).to_proc

  end
end
