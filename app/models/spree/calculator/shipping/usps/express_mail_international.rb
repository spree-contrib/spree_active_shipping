module Spree
  module Calculator::Shipping
    module Usps
      class ExpressMailInternational < Spree::Calculator::Shipping::Usps::Base
        # http://pe.usps.com/text/imm/ab_001.htm .. http://pe.usps.com/text/imm/tz_028.htm
        WEIGHT_LIMITS = {
          "AL"=>66, "DZ"=>44, "AD"=>66, "AO"=>44, "AI"=>55, "AR"=>44, "AM"=>44, "AW"=>44, "AU"=>44, "AT"=>66, "AZ"=>70,
          "BS"=>22, "BH"=>44, "BD"=>44, "BB"=>66, "BY"=>44, "BE"=>66, "BZ"=>66, "BJ"=>66, "BM"=>44, "BT"=>66, "BO"=>66,
          "BA"=>66, "BW"=>66, "BR"=>66, "BN"=>66, "BG"=>66, "BF"=>70, "BI"=>66, "KH"=>66, "CM"=>44, "CA"=>66, "CV"=>66,
          "KY"=>44, "CF"=>66, "TD"=>66, "CL"=>66, "CN"=>66, "CO"=>44, "CD"=>66, "CG"=>66, "CR"=>66, "CI"=>66, "HR"=>66,
          "CY"=>70, "CZ"=>70, "DK"=>66, "DJ"=>44, "DM"=>44, "DO"=>66, "EC"=>66, "EG"=>44, "SV"=>66, "GQ"=>44, "ER"=>66,
          "EE"=>66, "ET"=>66, "FO"=>44, "FJ"=>66, "FI"=>66, "FR"=>66, "GF"=>66, "PF"=>66, "GA"=>66, "GE"=>66, "DE"=>66,
          "GH"=>66, "GB"=>66, "GR"=>66, "GD"=>66, "GP"=>66, "GT"=>66, "GN"=>44, "GW"=>44, "GY"=>66, "HT"=>66, "HN"=>44,
          "HK"=>66, "HU"=>66, "IS"=>66, "IN"=>70, "ID"=>66, "IQ"=>44, "IE"=>66, "IL"=>44, "IT"=>66, "JM"=>66, "JP"=>66,
          "JO"=>66, "KZ"=>66, "KE"=>70, "KR"=>66, "KW"=>66, "KG"=>66, "LA"=>66, "LV"=>66, "LS"=>66, "LR"=>44, "LI"=>66,
          "LT"=>70, "LU"=>66, "MO"=>70, "MK"=>66, "MG"=>66, "MW"=>44, "MY"=>66, "MV"=>66, "ML"=>66, "MT"=>44, "MQ"=>66,
          "MR"=>66, "MU"=>66, "MX"=>44, "MD"=>70, "MN"=>66, "MA"=>68, "MZ"=>66, "NA"=>22, "NR"=>44, "NP"=>69, "NL"=>66,
          "AN"=>66, "NC"=>66, "NZ"=>66, "NI"=>55, "NE"=>70, "NG"=>66, "NO"=>66, "OM"=>66, "PK"=>66, "PA"=>66, "PG"=>55,
          "PY"=>55, "PE"=>70, "PH"=>44, "PL"=>44, "PT"=>66, "QA"=>66, "RO"=>70, "RU"=>70, "RW"=>66, "KN"=>66, "LC"=>44,
          "VC"=>44, "SM"=>66, "SA"=>66, "SN"=>66, "RS"=>66, "SC"=>66, "SL"=>66, "SG"=>66, "SK"=>66, "SI"=>66, "SB"=>66,
          "ZA"=>66, "ES"=>66, "LK"=>66, "SD"=>66, "SZ"=>66, "SE"=>66, "CH"=>66, "SY"=>44, "TW"=>33, "TJ"=>66, "TZ"=>66,
          "TH"=>66, "TG"=>66, "TO"=>66, "TT"=>66, "TN"=>66, "TR"=>66, "TM"=>66, "TC"=>66, "UG"=>66, "UA"=>44, "AE"=>70,
          "UY"=>44, "UZ"=>66, "VU"=>55, "VA"=>66, "VE"=>66, "VN"=>66, "WS"=>44, "YE"=>66, "ZM"=>66, "ZW"=>44
        }

        def self.service_code
          1 #Priority Mail Express International™
        end

        def self.description
          I18n.t("usps.express_mail_intl")
        end

        protected
        # weight limit in ounces or zero (if there is no limit)
        def max_weight_for_country(country)
          limit = WEIGHT_LIMITS[country.iso]
          if limit.nil?
            raise Spree::ShippingError.new("#{I18n.t(:shipping_error)}: This shipping method isn't available for #{country.name}")
          end
          limit * 16	# weights are operated on in ounces
        end
      end
    end
  end
end
