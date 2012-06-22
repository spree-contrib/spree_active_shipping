# This is a base calculator for shipping calcualations using the ActiveShipping plugin.  It is not intended to be
# instantiated directly.  Create subclass for each specific shipping method you wish to support instead.
#
# Digest::MD5 is used for cache_key generation.
require 'digest/md5'
require_dependency 'spree/calculator'

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
          timings = Rails.cache.fetch(cache_key(order)+"-timings") do
            timings = retrieve_timings(origin, destination, packages(order))
          end
          return nil if timings.nil? || !timings.is_a?(Hash) || timings.empty?
          return timings[self.description]

        end

        protected
        # weight limit in ounces or zero (if there is no limit)
        def max_weight_for_country(country)
          0
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
              # Canada Post specific error message
              elsif params.has_key?("eparcel") && params["eparcel"].has_key?("error") && params["eparcel"]["error"].has_key?("statusMessage")
                message = e.response.params["eparcel"]["error"]["statusMessage"]
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
            else
              message = re.message
            end
            Rails.cache.write @cache_key+'-', {} #write empty hash to cache to prevent constant re-lookups
            raise Spree::ShippingError.new("#{I18n.t(:shipping_error)}: #{message}")
          end
        end


        
        private
        
        def convert_order_to_weights_array(order)
          multiplier = Spree::ActiveShipping::Config[:unit_multiplier]
          default_weight = Spree::ActiveShipping::Config[:default_weight]
          max_weight = max_weight_for_country(order.ship_address.country)
          
          weights = order.line_items.map do |line_item|
            item_weight = line_item.variant.weight.present? ? line_item.variant.weight : default_weight
            item_weight *= multiplier
            quantity = line_item.quantity
            if max_weight <= 0
              item_weight * quantity
            else
              if item_weight < max_weight
                max_quantity = (max_weight/item_weight).floor
                if quantity < max_quantity
                  item_weight * quantity
                else
                  new_items = []
                  while quantity > 0 do
                    new_quantity = [max_quantity, quantity].min
                    new_items << (item_weight * new_quantity)
                    quantity -= new_quantity
                  end
                  new_items
                end
              else
                raise Spree::ShippingError.new("#{I18n.t(:shipping_error)}: The maximum per package weight for the selected service from the selected country is #{max_weight} ounces.")
              end
            end
          end
          weights.flatten.sort
        end

        # Generates an array of Package objects based on the quantities and weights of the variants in the line items
        def packages(order)
          units = Spree::ActiveShipping::Config[:units].to_sym
          packages = []
          weights = convert_order_to_weights_array(order)
          max_weight = max_weight_for_country(order.ship_address.country)
          
          if max_weight <= 0
            packages << Package.new(weights.sum, [], :units => units)
          else
            package_weight = 0
            weights.each do |li_weight|
              if package_weight + li_weight <= max_weight
                package_weight += li_weight
              else
                packages << Package.new(package_weight, [], :units => units)
                package_weight = li_weight
              end
            end
            packages << Package.new(package_weight, [], :units => units) if package_weight > 0
          end
          
          packages
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
