# This is a base calculator for shipping calcualations using the ActiveShipping plugin.  It is not intended to be
# instantiated directly.  Create subclass for each specific shipping method you wish to support instead.
#
# Digest::MD5 is used for cache_key generation.
require 'digest/md5'
require 'iconv' if RUBY_VERSION.to_f < 1.9
require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module ActiveShipping
      class Base < ShippingCalculator
        include ActiveMerchant::Shipping

        def self.service_name
          self.description
        end

        def compute(object)
          if object.is_a?(Array)
            order = object.first.order
          elsif object.is_a?(Spree::Stock::Package) 
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

          rates_result = Rails.cache.fetch(cache_key(object)) do
            order_packages = packages(object)
            if order_packages.empty?
              {}
            else
              binding.pry
              retrieve_rates(origin, destination, order_packages)
            end
          end


          raise rates_result if rates_result.kind_of?(Spree::ShippingError)
          return nil if rates_result.empty?
          rate = rates_result[self.class.description]

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
          timings_result = Rails.cache.fetch(cache_key(order)+"-timings") do
            retrieve_timings(origin, destination, packages(order))
          end
          raise timings_result if timings_result.kind_of?(Spree::ShippingError)
          return nil if timings_result.nil? || !timings_result.is_a?(Hash) || timings_result.empty?
          return timings_result[self.description]

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
            rates = response.rates.collect do |rate|
              # decode html entities for xml-based APIs, ie Canada Post
              if RUBY_VERSION.to_f < 1.9
                service_name = Iconv.iconv('UTF-8//IGNORE', 'UTF-8', rate.service_name).first
              else
                service_name = rate.service_name.encode("UTF-8")
              end
              [CGI.unescapeHTML(service_name), rate.price]
            end
            rate_hash = Hash[*rates.flatten]
            return rate_hash
          rescue ActiveMerchant::ActiveMerchantError => e

            if [ActiveMerchant::ResponseError, ActiveMerchant::Shipping::ResponseError].include?(e.class) && e.response.is_a?(ActiveMerchant::Shipping::Response)
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
              message = e.message
            end

            error = Spree::ShippingError.new("#{I18n.t(:shipping_error)}: #{message}")
            Rails.cache.write @cache_key, error #write error to cache to prevent constant re-lookups
            raise error
          end

        end


        def retrieve_timings(origin, destination, packages)
          begin
            if carrier.respond_to?(:find_time_in_transit)
              response = carrier.find_time_in_transit(origin, destination, packages)
              return response
            end
          rescue ActiveMerchant::Shipping::ResponseError => re
            if re.response.is_a?(ActiveMerchant::Shipping::Response)
              params = re.response.params
              if params.has_key?("Response") && params["Response"].has_key?("Error") && params["Response"]["Error"].has_key?("ErrorDescription")
                message = params["Response"]["Error"]["ErrorDescription"]
              else
                message = re.message
              end
            else
              message = re.message
            end

            error = Spree::ShippingError.new("#{I18n.t(:shipping_error)}: #{message}")
            Rails.cache.write @cache_key+"-timings", error #write error to cache to prevent constant re-lookups
            raise error
          end
        end



        private

        def convert_order_to_weights_array(package)
          multiplier = Spree::ActiveShipping::Config[:unit_multiplier]
          default_weight = Spree::ActiveShipping::Config[:default_weight]
          max_weight = get_max_weight(package.order)

          weights = package.contents.map do |item|
            item_weight = item.variant.weight.to_f
            item_weight = default_weight if item_weight <= 0
            item_weight *= multiplier

            quantity = item.quantity
            if max_weight <= 0
              item_weight * quantity
            elsif item_weight == 0
              0
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

        def convert_order_to_item_packages_array(package)
          multiplier = Spree::ActiveShipping::Config[:unit_multiplier]
          max_weight = get_max_weight(package.order)
          packages = []

          package.contents.each do |product_package|
            product_package.each do |item|
              next unless item.is_a?(Spree::Stock::Package::ContentItem)

              if item.weight.to_f <= max_weight or max_weight == 0
                product_package.quantity.times do |idx|
                  packages << [item.weight * multiplier, item.depth, item.width, item.height]
                end
              else
                raise Spree::ShippingError.new("#{I18n.t(:shipping_error)}: The maximum per package weight for the selected service from the selected country is #{max_weight} ounces.")
              end
            end
          end

          packages
        end

        # Generates an array of Package objects based on the quantities and weights of the variants in the line items
        def packages(package)
          units = Spree::ActiveShipping::Config[:units].to_sym
          packages = []
          weights = convert_order_to_weights_array(package)
          max_weight = get_max_weight(package.order)
          item_specific_packages = convert_order_to_item_packages_array(package)

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

          item_specific_packages.each do |package|
            packages << Package.new(package.at(0), [package.at(1), package.at(2), package.at(3)], :units => :imperial)
          end
          packages
        end

        def get_max_weight(order)
          max_weight = max_weight_for_country(order.ship_address.country)
          max_weight_per_package = Spree::ActiveShipping::Config[:max_weight_per_package] * Spree::ActiveShipping::Config[:unit_multiplier]
          if max_weight == 0 and max_weight_per_package > 0
            max_weight = max_weight_per_package
          elsif max_weight > 0 and max_weight_per_package < max_weight and max_weight_per_package > 0
            max_weight = max_weight_per_package
          end

          max_weight
        end

        def cache_key(package)
          addr = package.order.ship_address
          line_items_hash = Digest::MD5.hexdigest(package.order.line_items.map {|li| li.variant_id.to_s + "_" + li.quantity.to_s }.join("|"))
          @cache_key = "#{carrier.name}-#{package.order.number}-#{addr.country.iso}-#{addr.state ? addr.state.abbr : addr.state_name}-#{addr.city}-#{addr.zipcode}-#{line_items_hash}-#{I18n.locale}".gsub(" ","")
        end
      end
    end
  end
end
