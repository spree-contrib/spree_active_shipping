module Spree
  module ActiveShipping
    module UpsOverride
      def self.included(base)

        base.class_eval do

          def build_rate_request(origin, destination, packages, options={})
             packages = Array(packages)
             xml_request = XmlNode.new('RatingServiceSelectionRequest') do |root_node|
               root_node << XmlNode.new('Request') do |request|
                 request << XmlNode.new('RequestAction', 'Rate')
                 request << XmlNode.new('RequestOption', 'Shop')
                 # not implemented: 'Rate' RequestOption to specify a single service query
                 # request << XmlNode.new('RequestOption', ((options[:service].nil? or options[:service] == :all) ? 'Shop' : 'Rate'))
               end

               pickup_type = options[:pickup_type] || :daily_pickup

               root_node << XmlNode.new('PickupType') do |pickup_type_node|
                 pickup_type_node << XmlNode.new('Code', ::ActiveShipping::UPS::PICKUP_CODES[pickup_type])
                 # not implemented: PickupType/PickupDetails element
               end
               cc = options[:customer_classification] || ::ActiveShipping::UPS::DEFAULT_CUSTOMER_CLASSIFICATIONS[pickup_type]
               root_node << XmlNode.new('CustomerClassification') do |cc_node|
                 cc_node << XmlNode.new('Code', ::ActiveShipping::UPS::CUSTOMER_CLASSIFICATIONS[cc])
               end

               root_node << XmlNode.new('Shipment') do |shipment|
                 # not implemented: Shipment/Description element
                 shipment << build_location_node('Shipper', (options[:shipper] || origin), options)
                 shipment << build_location_node('ShipTo', destination, options)
                 if options[:shipper] and options[:shipper] != origin
                   shipment << build_location_node('ShipFrom', origin, options)
                 end

                 # not implemented:  * Shipment/ShipmentWeight element
                 #                   * Shipment/ReferenceNumber element
                 #                   * Shipment/Service element
                 #                   * Shipment/PickupDate element
                 #                   * Shipment/ScheduledDeliveryDate element
                 #                   * Shipment/ScheduledDeliveryTime element
                 #                   * Shipment/AlternateDeliveryTime element
                 #                   * Shipment/DocumentsOnly element

                 packages.each do |package|


                   imperial = ['US','LR','MM'].include?(origin.country_code(:alpha2))

                   shipment << XmlNode.new("Package") do |package_node|

                     # not implemented:  * Shipment/Package/PackagingType element
                     #                   * Shipment/Package/Description element

                     package_node << XmlNode.new("PackagingType") do |packaging_type|
                       packaging_type << XmlNode.new("Code", '02')
                     end

                     package_node << XmlNode.new("Dimensions") do |dimensions|
                       dimensions << XmlNode.new("UnitOfMeasurement") do |units|
                         units << XmlNode.new("Code", imperial ? 'IN' : 'CM')
                       end
                       [:length,:width,:height].each do |axis|
                         value = ((imperial ? package.inches(axis) : package.cm(axis)).to_f*1000).round/1000.0 # 3 decimals
                         dimensions << XmlNode.new(axis.to_s.capitalize, [value,0.1].max)
                       end
                     end

                     package_node << XmlNode.new("PackageWeight") do |package_weight|
                       package_weight << XmlNode.new("UnitOfMeasurement") do |units|
                         units << XmlNode.new("Code", imperial ? 'LBS' : 'KGS')
                       end

                       value = ((imperial ? package.lbs : package.kgs).to_f*1000).round/1000.0 # 3 decimals
                       package_weight << XmlNode.new("Weight", [value,0.1].max)
                     end

                     # not implemented:  * Shipment/Package/LargePackageIndicator element
                     #                   * Shipment/Package/ReferenceNumber element
                     #                   * Shipment/Package/PackageServiceOptions element
                     #                   * Shipment/Package/AdditionalHandling element
                   end

                 end

                 # not implemented:  * Shipment/ShipmentServiceOptions element
                 #                   * Shipment/RateInformation element

                 #SPREE OVERRIDE Negotiated Rates
                 if (origin_account = @options[:origin_account].presence || options[:origin_account].presence)
                   shipment << XmlNode.new("RateInformation") do |rate_information|
                     rate_information << XmlNode.new("NegotiatedRatesIndicator", '')
                   end
                 end
               end

             end
             xml_request.to_s
          end

          def build_time_in_transit_request(origin, destination, packages, options={})
            packages = Array(packages)
            xml_request = XmlNode.new('TimeInTransitRequest') do |root_node|
              root_node << XmlNode.new('Request') do |request|
                request << XmlNode.new('TransactionReference') do |transaction_reference|
                  transaction_reference << XmlNode.new('CustomerContext', 'Time in Transit')
                  transaction_reference << XmlNode.new('XpciVersion', '1.0002')
                end
                request << XmlNode.new('RequestAction', 'TimeInTransit')
              end
              root_node << XmlNode.new('TransitFrom') do |transit_from|
                transit_from << XmlNode.new('AddressArtifactFormat') do |address_artifact_format|
                  address_artifact_format << XmlNode.new('PoliticalDivision2',origin.city)
                  address_artifact_format << XmlNode.new('PoliticalDivision1',origin.state)
                  address_artifact_format << XmlNode.new('CountryCode',origin.country_code(:alpha2))
                  address_artifact_format << XmlNode.new('PostcodePrimaryLow',origin.postal_code)
                end
              end

              root_node << XmlNode.new('TransitTo') do |transit_to|
                transit_to << XmlNode.new('AddressArtifactFormat') do |address_artifact_format|
                  address_artifact_format << XmlNode.new('PoliticalDivision2',destination.city)
                  address_artifact_format << XmlNode.new('PoliticalDivision1',destination.state)
                  address_artifact_format << XmlNode.new('CountryCode',destination.country_code(:alpha2))
                  address_artifact_format << XmlNode.new('PostcodePrimaryLow',destination.postal_code)
                end
              end

              root_node << XmlNode.new("ShipmentWeight") do |shipment_weight|
                shipment_weight << XmlNode.new("UnitOfMeasurement") do |units|
                  units << XmlNode.new("Code", 'LBS')
                end

                value = ((packages[0].lbs).to_f*1000).round/1000.0 # 3 decimals
                shipment_weight << XmlNode.new("Weight", [value,0.1].max)
              end

              root_node << XmlNode.new("InvoiceLineTotal") do |invoice_line_total|
                invoice_line_total << XmlNode.new("CurrencyCode","USD")
                invoice_line_total << XmlNode.new("MonetaryValue","50")
              end

              root_node << XmlNode.new("PickupDate",Date.today.strftime("%Y%m%d"))


            end
            xml_request.to_s
          end

          def build_location_node(name,location,options={})
            # not implemented:  * Shipment/Shipper/Name element
            #                   * Shipment/(ShipTo|ShipFrom)/CompanyName element
            #                   * Shipment/(Shipper|ShipTo|ShipFrom)/AttentionName element
            #                   * Shipment/(Shipper|ShipTo|ShipFrom)/TaxIdentificationNumber element
            location_node = XmlNode.new(name) do |location_node|
              location_node << XmlNode.new('PhoneNumber', location.phone.gsub(/[^\d]/,'')) unless location.phone.blank?
              location_node << XmlNode.new('FaxNumber', location.fax.gsub(/[^\d]/,'')) unless location.fax.blank?

              if name == 'Shipper' and (origin_account = @options[:origin_account].presence || options[:origin_account].presence)
                location_node << XmlNode.new('ShipperNumber', origin_account)
              elsif name == 'ShipTo' and (destination_account = @options[:destination_account] || options[:destination_account])
                location_node << XmlNode.new('ShipperAssignedIdentificationNumber', destination_account)
              end

              location_node << XmlNode.new('Address') do |address|
                address << XmlNode.new("AddressLine1", location.address1) unless location.address1.blank?
                address << XmlNode.new("AddressLine2", location.address2) unless location.address2.blank?
                address << XmlNode.new("AddressLine3", location.address3) unless location.address3.blank?
                address << XmlNode.new("City", location.city) unless location.city.blank?
                address << XmlNode.new("StateProvinceCode", location.state) unless location.state.blank? #SPREE OVERRIDE
                  # StateProvinceCode required for negotiated rates but not otherwise, for some reason
                address << XmlNode.new("PostalCode", location.postal_code) unless location.postal_code.blank?
                address << XmlNode.new("CountryCode", location.country_code(:alpha2)) unless location.country_code(:alpha2).blank?
                address << XmlNode.new("ResidentialAddressIndicator", true) unless location.commercial? # the default should be that UPS returns residential rates for destinations that it doesn't know about
                # not implemented: Shipment/(Shipper|ShipTo|ShipFrom)/Address/ResidentialAddressIndicator element
              end
            end
          end

           def find_time_in_transit(origin, destination, packages, options={})
             origin, destination = upsified_location(origin), upsified_location(destination)
             options = @options.merge(options)
             packages = Array(packages)
             access_request = build_access_request
             rate_request = build_time_in_transit_request(origin, destination, packages, options)
             response = ssl_post("https://www.ups.com/ups.app/xml/TimeInTransit", "<?xml version=\"1.0\"?>"+access_request+"<?xml version=\"1.0\"?>"+rate_request)
             parse_time_in_transit_response(origin, destination, packages,response, options)
          end

          def find_rates(origin, destination, packages, options={})
            origin, destination = upsified_location(origin), upsified_location(destination)
            options = @options.merge(options)
            packages = Array(packages)
            access_request = build_access_request
            rate_request = build_rate_request(origin, destination, packages, options)
            response = commit(:rates, save_request(access_request + rate_request), (options[:test] || false))
            parse_rate_response(origin, destination, packages, response, options)
          end


          def parse_time_in_transit_response(origin, destination, packages, response, options={})

            time_code_mapping = {
              "1DA" => "01",
              "2DA" => "02",
              "GND" => "03",
              "01" => "07",
              "05" => "08",
              "03" => "11",
              "3DS" => "12",
              "1DP" => "13",
              "1DM" => "14",
              "21" => "54",
              "2DM" => "59"
            }

            rates = []
            xml = REXML::Document.new(response)
            success = response_success?(xml)
            message = response_message(xml)
            if success
              rate_estimates = {}
              xml.elements.each('/*/TransitResponse/ServiceSummary') do |service_summary|
                service_code    = service_summary.get_text('Service/Code').to_s
                service_code_2 = time_code_mapping[service_code]
                service_desc    = service_summary.get_text('Service/Description').to_s
                guaranteed_code = service_summary.get_text('Guaranteed/Code').to_s
                business_transit_days = service_summary.get_text('EstimatedArrival/BusinessTransitDays').to_s
                date = service_summary.get_text('EstimatedArrival/Date').to_s
                rate_estimates[service_name_for(origin, service_code_2)] = {:service_code => service_code, :service_code_2 => service_code_2, :service_desc => service_desc,
                    :guaranteed_code => guaranteed_code, :business_transit_days => business_transit_days,
                    :date => date}
              end
            end
            return rate_estimates
          end



          def parse_rate_response(origin, destination, packages, response, options={})
            rates = []
            xml = REXML::Document.new(response)
            success = response_success?(xml)
            message = response_message(xml)
            transits = options[:transit]
            if success
              rate_estimates = []

              xml.elements.each('/*/RatedShipment') do |rated_shipment|
                service_code    = rated_shipment.get_text('Service/Code').to_s
                service    = rated_shipment.get_text('Service/Code').to_s
                negotiated_rate = rated_shipment.get_text('NegotiatedRates/NetSummaryCharges/GrandTotal/MonetaryValue').to_s
                total_price     = negotiated_rate.blank? ? rated_shipment.get_text('TotalCharges/MonetaryValue').to_s.to_f : negotiated_rate.to_f
                currency        = negotiated_rate.blank? ? rated_shipment.get_text('TotalCharges/CurrencyCode').to_s : rated_shipment.get_text('NegotiatedRates/NetSummaryCharges/GrandTotal/CurrencyCode').to_s

                rate_estimates << ::ActiveShipping::RateEstimate.new(origin, destination, ::ActiveShipping::UPS.name,
                                    service_name_for(origin, service_code),
                                    :total_price => total_price,
                                    :currency => currency,
                                    :service_code => service_code,
                                    :packages => packages
                                    )
              end
            end
            ::ActiveShipping::RateResponse.new(success, message, Hash.from_xml(response).values.first, :rates => rate_estimates, :xml => response, :request => last_request)
          end
        end
      end


    end
  end
end
