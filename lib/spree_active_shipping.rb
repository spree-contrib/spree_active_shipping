require 'spree_core'
require 'active_shipping'

module ActiveShippingExtension
  class Engine < Rails::Engine
    def self.activate
      #next two globs are workarounds for production issues with Passenger/Unicorn
      #anyone care to offer something a little cleaner?
      Dir.glob(File.join(File.dirname(__FILE__), "../app/models/calculator/active_shipping.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end 

      Dir.glob(File.join(File.dirname(__FILE__), "../app/models/calculator/usps/base.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end 

      Dir.glob(File.join(File.dirname(__FILE__), "../app/models/calculator/**/*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      (
        Calculator::Fedex::Base.descendants +
        Calculator::Ups::Base.descendants +
        Calculator::Usps::Base.descendants
      ).each(&:register)

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
