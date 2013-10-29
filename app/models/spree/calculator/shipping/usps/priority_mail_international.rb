module Spree
  module Calculator::Shipping
    module Usps
      class PriorityMailInternational < Spree::Calculator::Shipping::Usps::Base
        # http://pe.usps.com/text/imm/ab_001.htm .. http://pe.usps.com/text/imm/tz_028.htm
        WEIGHT_LIMITS = {
          "AI"=>22, "AG"=>22, "BS"=>22, "MM"=>22, "GQ"=>22, "JM"=>22, "PN"=>22,
          "VC"=>22, "AL"=>44, "DZ"=>44, "AO"=>44, "AR"=>44, "AM"=>44, "AW"=>44, "BH"=>44, "BD"=>44, "BB"=>44, "BZ"=>44,
          "BM"=>44, "BA"=>44, "VG"=>44, "BN"=>44, "CV"=>44, "KY"=>44, "TD"=>44, "CL"=>44, "KM"=>44, "CG"=>44, "DJ"=>44,
          "DM"=>44, "DO"=>44, "SV"=>44, "ER"=>44, "FJ"=>44, "GA"=>44, "GE"=>44, "GI"=>44, "GR"=>44, "GD"=>44, "GT"=>44,
          "GY"=>44, "HN"=>44, "HU"=>44, "IN"=>44, "ID"=>44, "IR"=>44, "IQ"=>44, "IL"=>44, "KZ"=>44, "KI"=>44, "KR"=>44,
          "KG"=>44, "LA"=>44, "LS"=>44, "LR"=>44, "LY"=>44, "MG"=>44, "MR"=>44, "MU"=>44, "MX"=>44, "MS"=>44, "NA"=>44,
          "NR"=>44, "NP"=>44, "NL"=>44, "AN"=>44, "OM"=>44, "PG"=>44, "PH"=>44, "PL"=>44, "RU"=>44, "KN"=>44, "SH"=>44,
          "LC"=>44, "ST"=>44, "SB"=>44, "ES"=>44, "SD"=>44, "SR"=>44, "SZ"=>44, "TW"=>44, "TO"=>44, "TT"=>44, "TM"=>44,
          "TC"=>44, "VU"=>44, "VA"=>44, "WS"=>44, "ZW"=>44, "HT"=>55, "TV"=>55, "AF"=>66, "AD"=>66, "AU"=>66, "AT"=>66,
          "BY"=>66, "BE"=>66, "BJ"=>66, "BT"=>66, "BW"=>66, "BR"=>66, "BF"=>66, "BI"=>66, "CA"=>66, "KH"=>66, "CM"=>66,
          "CF"=>66, "CN"=>66, "CO"=>66, "CD"=>66, "CR"=>66, "CI"=>66, "HR"=>66, "DK"=>66, "EC"=>66, "EG"=>66, "ET"=>66,
          "FR"=>66, "GF"=>66, "PF"=>66, "GM"=>66, "GH"=>66, "GB"=>66, "MP"=>66, "GL"=>66, "GP"=>66, "GN"=>66, "GW"=>66,
          "HK"=>66, "IE"=>66, "IT"=>66, "JP"=>66, "JO"=>66, "KW"=>66, "LB"=>66, "LI"=>66, "LU"=>66, "MW"=>66, "MY"=>66,
          "MV"=>66, "ML"=>66, "MT"=>66, "MQ"=>66, "MN"=>66, "MA"=>66, "MZ"=>66, "NC"=>66, "NZ"=>66, "NI"=>66, "NG"=>66,
          "NO"=>66, "PY"=>66, "PT"=>66, "RE"=>66, "RW"=>66, "PM"=>66, "SM"=>66, "SA"=>66, "SN"=>66, "SL"=>66, "SG"=>66,
          "SK"=>66, "SI"=>66, "ZA"=>66, "LK"=>66, "SE"=>66, "CH"=>66, "TJ"=>66, "TZ"=>66, "TH"=>66, "TN"=>66, "TR"=>66,
          "UG"=>66, "UA"=>66, "UY"=>66, "VE"=>66, "WF"=>66, "YE"=>66, "ZM"=>66, "AZ"=>70, "BG"=>70, "CY"=>70, "CZ"=>70,
          "EE"=>70, "FO"=>70, "FI"=>70, "DE"=>70, "IS"=>70, "KE"=>70, "LV"=>70, "LT"=>70, "MO"=>70, "MK"=>70, "MD"=>70,
          "ME"=>70, "NE"=>70, "PK"=>70, "PA"=>70, "PE"=>70, "QA"=>70, "RO"=>70, "RS"=>70, "SC"=>70, "SY"=>70, "TG"=>70,
          "AE"=>70, "UZ"=>70, "VN"=>70
        }

        def self.service_code
          2 #Priority Mail International®
        end

        def self.description
          I18n.t("usps.priority_mail_international")
        end

        protected
        # weight limit in ounces or zero (if there is no limit)
        def max_weight_for_country(country)
          return WEIGHT_LIMITS[country.iso] unless WEIGHT_LIMITS[country.iso].nil?
          raise Spree::ShippingError.new("#{I18n.t(:shipping_error)}: This shipping method isn't available for #{country.name}")
        end
      end
    end
  end
end
