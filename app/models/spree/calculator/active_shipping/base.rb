# This is a base calculator for shipping calcualations using the ActiveShipping plugin.  It is not intended to be
# instantiated directly.  Create subclass for each specific shipping method you wish to support instead.
#
# Digest::MD5 is used for cache_key generation.
require 'digest/md5'
module Spree
  class Calculator < ActiveRecord::Base
    module ActiveShipping
      class Base < Calculator
        include ActiveMerchant::Shipping

        def self.service_name
          self.description
        end

        def compute(object)
          if object.is_a?(Array)
            order = object.first.order
          elsif object.is_a?(Shipment)
            order = object.order
          else
            order = object
          end
          origin= Location.new(:country => Spree::ActiveShipping::Config[:origin_country],
                               :city => Spree::ActiveShipping::Config[:origin_city],
                               :state => Spree::ActiveShipping::Config[:origin_state],
                               :zip => Spree::ActiveShipping::Config[:origin_zip])

          addr = order.ship_address

          destination = Location.new(:country => addr.country.iso,
                                     :state => (addr.state ? addr.state.abbr : addr.state_name),
                                     :city => addr.city,
                                     :zip => addr.zipcode)

          rates = Rails.cache.fetch(cache_key(order)) do
            rates = retrieve_rates(origin, destination, packages(order))
          end

          return nil if rates.empty?
          rate = rates[self.class.description]
          return nil unless rate
          rate = rate.to_f + (Spree::ActiveShipping::Config[:handling_fee].to_f || 0.0)

          # divide by 100 since active_shipping rates are expressed as cents
          return rate/100.0
        end


        def timing(line_items)
          order = line_items.first.order
          origin      = Location.new(:country => Spree::ActiveShipping::Config[:origin_country],
                                     :city => Spree::ActiveShipping::Config[:origin_city],
                                     :state => Spree::ActiveShipping::Config[:origin_state],
                                     :zip => Spree::ActiveShipping::Config[:origin_zip])
          addr = order.ship_address
          destination = Location.new(:country => addr.country.iso,
                                     :state => (addr.state ? addr.state.abbr : addr.state_name),
                                     :city => addr.city,
                                     :zip => addr.zipcode)
          timings = Rails.cache.fetch(cache_key(line_items)+"-timings") do
            timings = retrieve_timings(origin, destination, packages(order))
          end
          return nil if timings.nil? || !timings.is_a?(Hash) || timings.empty?
          return timings[self.description]

        end

        private
        def retrieve_rates(origin, destination, packages)
          begin
            response = carrier.find_rates(origin, destination, packages)
            # turn this beastly array into a nice little hash
            rate_hash = Hash[*response.rates.collect { |rate| [rate.service_name, rate.price] }.flatten]
            return rate_hash
          rescue ActiveMerchant::ActiveMerchantError => e

            if [ActiveMerchant::ResponseError, ActiveMerchant::Shipping::ResponseError].include? e.class
              params = e.response.params
              if params.has_key?("Response") && params["Response"].has_key?("Error") && params["Response"]["Error"].has_key?("ErrorDescription")
                message = params["Response"]["Error"]["ErrorDescription"]
              else
                message = e.message
              end
            else
              message = e.to_s
            end

            Rails.cache.write @cache_key, {} #write empty hash to cache to prevent constant re-lookups

            raise Spree::ShippingError.new("#{I18n.t(:shipping_error)}: #{message}")
          end

        end


        def retrieve_timings(origin, destination, packages)
          begin
            if carrier.respond_to?(:find_time_in_transit)
              response = carrier.find_time_in_transit(origin, destination, packages)
              return response
            end
          rescue ActiveMerchant::Shipping::ResponseError => re
            params = re.response.params
            if params.has_key?("Response") && params["Response"].has_key?("Error") && params["Response"]["Error"].has_key?("ErrorDescription")
              message = params["Response"]["Error"]["ErrorDescription"]
              elsee
              message = re.message
            end
            Rails.cache.write @cache_key+'-', {} #write empty hash to cache to prevent constant re-lookups
            raise Spree::ShippingError.new("#{I18n.t(:shipping_error)}: #{message}")
          end
        end


        private

        # Generates an array of Package objects based on the quantities and weights of the variants in the line items
        def packages(order)
          multiplier = Spree::ActiveShipping::Config[:unit_multiplier]
          default_weight = Spree::ActiveShipping::Config[:default_weight]
          
          weight = order.line_items.inject(0) do |weight, line_item|
            item_weight = line_item.variant.weight.present? ? line_item.variant.weight : default_weight
            weight + (line_item.quantity * item_weight * multiplier)
          end
          
          package = Package.new(weight, [], :units => Spree::ActiveShipping::Config[:units].to_sym)
          [package]
        end

        def cache_key(order)
          addr = order.ship_address
          line_items_hash = Digest::MD5.hexdigest(order.line_items.map {|li| li.variant_id.to_s + "_" + li.quantity.to_s }.join("|"))
          @cache_key = "#{carrier.name}-#{order.number}-#{addr.country.iso}-#{addr.state ? addr.state.abbr : addr.state_name}-#{addr.city}-#{addr.zipcode}-#{line_items_hash}".gsub(" ","")
        end
      end
    end
  end
end
