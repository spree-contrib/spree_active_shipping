require 'spree_core'
require 'active_shipping'

module ActiveShippingExtension
  class Engine < Rails::Engine
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/models/calculator/**/base.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      #Only required until following active_shipping commit is merged (add negotiated rates).
      #http://github.com/BDQ/active_shipping/commit/2f2560d53aa7264383e5a35deb7264db60eb405a
      ActiveMerchant::Shipping::UPS.send(:include, Spree::ActiveShipping::UpsOverride)
    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare &method(:activate).to_proc

    initializer "spree_active_shipping.register.calculators" do |app|
      Dir.glob(File.join(File.dirname(__FILE__), "../app/models/calculator/**/*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      app.config.spree.calculators.shipping_methods.concat( 
        Calculator::Fedex::Base.descendants +
        Calculator::Ups::Base.descendants +
        Calculator::Usps::Base.descendants
      )
    end
  end

end
