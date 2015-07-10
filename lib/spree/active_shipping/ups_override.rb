module Spree
  module ActiveShipping
    module UpsOverride
      def self.included(base)

        base.class_eval do

          def build_rate_request(origin, destination, packages, options = {})
            xml_builder = Nokogiri::XML::Builder.new do |xml|
              xml.RatingServiceSelectionRequest do
                xml.Request do
                  xml.RequestAction('Rate')
                  xml.RequestOption('Shop')
                  # not implemented: 'Rate' RequestOption to specify a single service query
                  # xml.RequestOption((options[:service].nil? or options[:service] == :all) ? 'Shop' : 'Rate')
                end

                pickup_type = options[:pickup_type] || :daily_pickup

                xml.PickupType do
                  xml.Code(::ActiveShipping::UPS::PICKUP_CODES[pickup_type])
                  # not implemented: PickupType/PickupDetails element
                end

                cc = options[:customer_classification] || ::ActiveShipping::UPS::DEFAULT_CUSTOMER_CLASSIFICATIONS[pickup_type]
                xml.CustomerClassification do
                  xml.Code(::ActiveShipping::UPS::CUSTOMER_CLASSIFICATIONS[cc])
                end

                xml.Shipment do
                  # not implemented: Shipment/Description element
                  build_location_node(xml, 'Shipper', (options[:shipper] || origin), options)
                  build_location_node(xml, 'ShipTo', destination, options)
                  build_location_node(xml, 'ShipFrom', origin, options) if options[:shipper] && options[:shipper] != origin

                  # not implemented:  * Shipment/ShipmentWeight element
                  #                   * Shipment/ReferenceNumber element
                  #                   * Shipment/Service element
                  #                   * Shipment/PickupDate element
                  #                   * Shipment/ScheduledDeliveryDate element
                  #                   * Shipment/ScheduledDeliveryTime element
                  #                   * Shipment/AlternateDeliveryTime element
                  #                   * Shipment/DocumentsOnly element

                  Array(packages).each do |package|
                    options[:imperial] ||= ::ActiveShipping::UPS::IMPERIAL_COUNTRIES.include?(origin.country_code(:alpha2))
                    build_package_node(xml, package, options)
                  end

                  # Following section trigger UPS API check the state, and thus the estimation fail
                  # not implemented:  * Shipment/ShipmentServiceOptions element
                  #SPREE OVERRIDE
                  #if options[:negotiated_rates] || @options[:origin_account] || options[:origin_account]
                  #  xml.RateInformation do
                  #    xml.NegotiatedRatesIndicator
                  #  end
                  #end
                end
              end
            end
            xml_builder.to_xml
          end

          def build_time_in_transit_request(origin, destination, packages, options={})
            packages = Array(packages)

            xml_builder = Nokogiri::XML::Builder.new do |xml|
              xml.TimeInTransitRequest do 
                xml.Request do
                  xml.TransactionReference do
                    xml.CustomerContext('Time in Transit')
                    xml.XpciVersion('1.0002')
                  end
                  xml.RequestAction('TimeInTransit')
                end
                xml.TransitFrom do
                  xml.AddressArtifactFormat do
                    xml.PoliticalDivision2(origin.city)
                    xml.PoliticalDivision1(origin.state)
                    xml.CountryCode(origin.country_code(:alpha2))
                    xml.PostcodePrimaryLow(origin.postal_code)
                  end
                end

                xml.TransitTo do
                  xml.AddressArtifactFormat do
                    xml.PoliticalDivision2(destination.city)
                    xml.PoliticalDivision1(destination.state)
                    xml.CountryCode(destination.country_code(:alpha2))
                    xml.PostcodePrimaryLow(destination.postal_code)
                  end
                end

                xml.ShipmentWeight do
                  xml.UnitOfMeasurement do
                    xml.Code('LBS')
                  end

                  value = ((packages[0].lbs).to_f*1000).round/1000.0 # 3 decimals
                  xml.Weight([value,0.1].max)
                end

                xml.InvoiceLineTotal do
                  xml.CurrencyCode("USD")
                  xml.MonetaryValue("50")
                end

                xml.PickupDate(Date.today.strftime("%Y%m%d"))

              end
            end
            xml_builder.to_xml
          end

          def build_location_node(xml, name, location, options = {})
            # not implemented:  * Shipment/Shipper/Name element
            #                   * Shipment/(ShipTo|ShipFrom)/CompanyName element
            #                   * Shipment/(Shipper|ShipTo|ShipFrom)/AttentionName element
            #                   * Shipment/(Shipper|ShipTo|ShipFrom)/TaxIdentificationNumber element
            xml.public_send(name) do
              if shipper_name = (location.name || location.company_name || options[:origin_name])
                xml.Name(shipper_name)
              end
              xml.PhoneNumber(location.phone.gsub(/[^\d]/, '')) unless location.phone.blank?
              xml.FaxNumber(location.fax.gsub(/[^\d]/, '')) unless location.fax.blank?

              if name == 'Shipper' and (origin_account = options[:origin_account] || @options[:origin_account])
                xml.ShipperNumber(origin_account)
              elsif name == 'ShipTo' and (destination_account = options[:destination_account] || @options[:destination_account])
                xml.ShipperAssignedIdentificationNumber(destination_account)
              end

              if name = (location.company_name || location.name || options[:origin_name])
                xml.CompanyName(name)
              end

              if phone = location.phone
                xml.PhoneNumber(phone)
              end

              if attn = location.name
                xml.AttentionName(attn)
              end

              xml.Address do
                xml.AddressLine1(location.address1) unless location.address1.blank?
                xml.AddressLine2(location.address2) unless location.address2.blank?
                xml.AddressLine3(location.address3) unless location.address3.blank?
                xml.City(location.city) unless location.city.blank?
                xml.StateProvinceCode(location.state) unless location.state.blank?
                # StateProvinceCode required for negotiated rates but not otherwise, for some reason
                xml.PostalCode(location.postal_code) unless location.postal_code.blank?
                xml.CountryCode(location.country_code(:alpha2)) unless location.country_code(:alpha2).blank?
                xml.ResidentialAddressIndicator(true) unless location.commercial? # the default should be that UPS returns residential rates for destinations that it doesn't know about
                # not implemented: Shipment/(Shipper|ShipTo|ShipFrom)/Address/ResidentialAddressIndicator element
              end
            end
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


          def parse_rate_response(origin, destination, packages, response, options={})
            xml = build_document(response, 'RatingServiceSelectionResponse')
            success = response_success?(xml)
            message = response_message(xml)

            if success
              rate_estimates = xml.root.css('> RatedShipment').map do |rated_shipment|
                service_code    = rated_shipment.at('Service/Code').text
                negotiated_rate = rated_shipment.at('NegotiatedRates/NetSummaryCharges/GrandTotal/MonetaryValue').try(:text)
                total_price     = negotiated_rate.blank? ? rated_shipment.at('TotalCharges/MonetaryValue').try(:text).to_f : negotiated_rate.to_f
                currency        = negotiated_rate.blank? ? rated_shipment.at('TotalCharges/CurrencyCode').text : rated_shipment.at('NegotiatedRates/NetSummaryCharges/GrandTotal/CurrencyCode').text

                ::ActiveShipping::RateEstimate.new(origin, destination, ::ActiveShipping::UPS.name,
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



          # Spree Methods -- Not Overridden
          def find_time_in_transit(origin, destination, packages, options={})
            origin, destination = upsified_location(origin), upsified_location(destination)
            options = @options.merge(options)
            packages = Array(packages)
            access_request = build_access_request
            rate_request = build_time_in_transit_request(origin, destination, packages, options)
            response = ssl_post("https://www.ups.com/ups.app/xml/TimeInTransit", "<?xml version=\"1.0\"?>"+access_request+"<?xml version=\"1.0\"?>"+rate_request)
            parse_time_in_transit_response(origin, destination, packages,response, options)
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
            xml = build_document(response, 'TimeInTransitResponse')
            success = response_success?(xml)
            message = response_message(xml)
            if success
              rate_estimates = {}

              xml.root.css('TransitResponse ServiceSummary').each do |service_summary|
                service_code    = service_summary.at('Service/Code').text
                service_code_2 = time_code_mapping[service_code]
                service_desc    = service_summary.at('Service/Description').text
                guaranteed_code = service_summary.at('Guaranteed/Code').text
                business_transit_days = service_summary.at('EstimatedArrival/BusinessTransitDays').text
                date = service_summary.at('EstimatedArrival/Date').text
                rate_estimates[service_name_for(origin, service_code_2)] = {:service_code => service_code, :service_code_2 => service_code_2, :service_desc => service_desc,
                    :guaranteed_code => guaranteed_code, :business_transit_days => business_transit_days,
                    :date => date}
              end
            end
            return rate_estimates
          end

        end
      end
    end
  end
end
