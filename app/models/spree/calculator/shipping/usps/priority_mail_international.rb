module Spree
  module Calculator::Shipping
    module Usps
      class PriorityMailInternational < Spree::Calculator::Shipping::Usps::Base
        # http://pe.usps.com/text/imm/ab_001.htm .. http://pe.usps.com/text/imm/tz_028.htm
        WEIGHT_LIMITS = {
          "AI"=>352, "AG"=>352, "BS"=>352, "MM"=>352, "GQ"=>352, "JM"=>352, "PN"=>352,
          "VC"=>352, "AL"=>704, "DZ"=>704, "AO"=>704, "AR"=>704, "AM"=>704, "AW"=>704, "BH"=>704, "BD"=>704, "BB"=>704, "BZ"=>704,
          "BM"=>704, "BA"=>704, "VG"=>704, "BN"=>704, "CV"=>704, "KY"=>704, "TD"=>704, "CL"=>704, "KM"=>704, "CG"=>704, "DJ"=>704,
          "DM"=>704, "DO"=>704, "SV"=>704, "ER"=>704, "FJ"=>704, "GA"=>704, "GE"=>704, "GI"=>704, "GR"=>704, "GD"=>704, "GT"=>704,
          "GY"=>704, "HN"=>704, "HU"=>704, "IN"=>704, "ID"=>704, "IR"=>704, "IQ"=>704, "IL"=>704, "KZ"=>704, "KI"=>704, "KR"=>704,
          "KG"=>704, "LA"=>704, "LS"=>704, "LR"=>704, "LY"=>704, "MG"=>704, "MR"=>704, "MU"=>704, "MX"=>704, "MS"=>704, "NA"=>704,
          "NR"=>704, "NP"=>704, "NL"=>704, "AN"=>704, "OM"=>704, "PG"=>704, "PH"=>704, "PL"=>704, "RU"=>704, "KN"=>704, "SH"=>704,
          "LC"=>704, "ST"=>704, "SB"=>704, "ES"=>704, "SD"=>704, "SR"=>704, "SZ"=>704, "TW"=>704, "TO"=>704, "TT"=>704, "TM"=>704,
          "TC"=>704, "VU"=>704, "VA"=>704, "WS"=>704, "ZW"=>704, "HT"=>880, "TV"=>880, "AF"=>1056, "AD"=>1056, "AU"=>1056, "AT"=>1056,
          "BY"=>1056, "BE"=>1056, "BJ"=>1056, "BT"=>1056, "BW"=>1056, "BR"=>1056, "BF"=>1056, "BI"=>1056, "CA"=>1056, "KH"=>1056, "CM"=>1056,
          "CF"=>1056, "CN"=>1056, "CO"=>1056, "CD"=>1056, "CR"=>1056, "CI"=>1056, "HR"=>1056, "DK"=>1056, "EC"=>1056, "EG"=>1056, "ET"=>1056,
          "FR"=>1056, "GF"=>1056, "PF"=>1056, "GM"=>1056, "GH"=>1056, "GB"=>1056, "MP"=>1056, "GL"=>1056, "GP"=>1056, "GN"=>1056, "GW"=>1056,
          "HK"=>1056, "IE"=>1056, "IT"=>1056, "JP"=>1056, "JO"=>1056, "KW"=>1056, "LB"=>1056, "LI"=>1056, "LU"=>1056, "MW"=>1056, "MY"=>1056,
          "MV"=>1056, "ML"=>1056, "MT"=>1056, "MQ"=>1056, "MN"=>1056, "MA"=>1056, "MZ"=>1056, "NC"=>1056, "NZ"=>1056, "NI"=>1056, "NG"=>1056,
          "NO"=>1056, "PY"=>1056, "PT"=>1056, "RE"=>1056, "RW"=>1056, "PM"=>1056, "SM"=>1056, "SA"=>1056, "SN"=>1056, "SL"=>1056, "SG"=>1056,
          "SK"=>1056, "SI"=>1056, "ZA"=>1056, "LK"=>1056, "SE"=>1056, "CH"=>1056, "TJ"=>1056, "TZ"=>1056, "TH"=>1056, "TN"=>1056, "TR"=>1056,
          "UG"=>1056, "UA"=>1056, "UY"=>1056, "VE"=>1056, "WF"=>1056, "YE"=>1056, "ZM"=>1056, "AZ"=>1120, "BG"=>1120, "CY"=>1120, "CZ"=>1120,
          "EE"=>1120, "FO"=>1120, "FI"=>1120, "DE"=>1120, "IS"=>1120, "KE"=>1120, "LV"=>1120, "LT"=>1120, "MO"=>1120, "MK"=>1120, "MD"=>1120,
          "ME"=>1120, "NE"=>1120, "PK"=>1120, "PA"=>1120, "PE"=>1120, "QA"=>1120, "RO"=>1120, "RS"=>1120, "SC"=>1120, "SY"=>1120, "TG"=>1120,
          "AE"=>1120, "UZ"=>1120, "VN"=>1120
        }

        def self.geo_group
          :international
        end

        def self.service_code
          "#{SERVICE_CODE_PREFIX[geo_group]}:2" #Priority Mail International®
        end

        def self.description
          I18n.t("usps.priority_mail_international")
        end

        protected
        # weight limit in ounces or zero (if there is no limit)
        def max_weight_for_country(country)
          return WEIGHT_LIMITS[country.iso]
        end
      end
    end
  end
end
