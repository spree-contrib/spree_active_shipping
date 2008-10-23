module Spree
  module ActiveShipping
    # Singleton class to access the shipping configuration object (ActiveShippingConfiguration.first by default) and it's preferences.
    #
    # Usage:
    #   Spree::ActiveShipping::Config[:foo]                  # Returns the foo preference
    #   Spree::ActiveShipping::Config[]                      # Returns a Hash with all the tax preferences
    #   Spree::ActiveShipping::Config.instance               # Returns the configuration object (ActiveShippingConfiguration.first)
    #   Spree::ActiveShipping::Config.set(preferences_hash)  # Set the active shipping preferences as especified in +preference_hash+
    class Config
      include Singleton
      include PreferenceAccess
    
      class << self
        def instance
          return nil unless ActiveRecord::Base.connection.tables.include?('configurations')
          ActiveShippingConfiguration.find_or_create_by_name("Default active_shipping configuration")
        end
      end
    end
  end
end