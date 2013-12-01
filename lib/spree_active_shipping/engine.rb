module Spree::ActiveShipping
end
module SpreeActiveShippingExtension
  class Engine < Rails::Engine

    initializer "spree.active_shipping.preferences", :before => :load_config_initializers do |app|
      Spree::ActiveShipping::Config = Spree::ActiveShippingConfiguration.new
    end

    def self.activate
      Dir[File.join(File.dirname(__FILE__), "../../app/models/spree/calculator/**/base.rb")].sort.each do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      #Only required until following active_shipping commit is merged (add negotiated rates).
      #http://github.com/BDQ/active_shipping/commit/2f2560d53aa7264383e5a35deb7264db60eb405a
      ActiveMerchant::Shipping::UPS.send(:include, Spree::ActiveShipping::UpsOverride)

      # Fix Canada Post "Ready to ship" package
      ActiveMerchant::Shipping::CanadaPost.send(:include, Spree::ActiveShipping::CanadaPostOverride)
    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare &method(:activate).to_proc

    initializer "spree_active_shipping.register.calculators" do |app|
      Dir[File.join(File.dirname(__FILE__), "../../app/models/spree/calculator/**/*.rb")].sort.each do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      app.config.spree.calculators.shipping_methods.concat(
        Spree::Calculator::Fedex::Base.descendants +
        Spree::Calculator::Ups::Base.descendants +
        Spree::Calculator::Usps::Base.descendants +
        Spree::Calculator::CanadaPost::Base.descendants
      )
    end

        # sets the manifests / assets to be precompiled, even when initialize_on_precompile is false
    initializer "spree.assets.precompile", :group => :all do |app|
      app.config.assets.precompile += %w[
        admin/product_packages/new.js
        admin/product_packages/edit.js
        admin/product_packages/index.js
      ]
    end
  end
end
