module Spree
  module Calculator::Shipping
    module Usps
      class ExpressMailInternational < Spree::Calculator::Shipping::Usps::Base
        # http://pe.usps.com/text/imm/ab_001.htm .. http://pe.usps.com/text/imm/tz_028.htm
        WEIGHT_LIMITS = {
          "AL"=>1056, "DZ"=>704, "AD"=>1056, "AO"=>704, "AI"=>880, "AR"=>704, "AM"=>704, "AW"=>704, "AU"=>704, "AT"=>1056, "AZ"=>1120,
          "BS"=>352, "BH"=>704, "BD"=>704, "BB"=>1056, "BY"=>704, "BE"=>1056, "BZ"=>1056, "BJ"=>1056, "BM"=>704, "BT"=>1056, "BO"=>1056,
          "BA"=>1056, "BW"=>1056, "BR"=>1056, "BN"=>1056, "BG"=>1056, "BF"=>1120, "BI"=>1056, "KH"=>1056, "CM"=>704, "CA"=>1056, "CV"=>1056,
          "KY"=>704, "CF"=>1056, "TD"=>1056, "CL"=>1056, "CN"=>1056, "CO"=>704, "CD"=>1056, "CG"=>1056, "CR"=>1056, "CI"=>1056, "HR"=>1056,
          "CY"=>1120, "CZ"=>1120, "DK"=>1056, "DJ"=>704, "DM"=>704, "DO"=>1056, "EC"=>1056, "EG"=>704, "SV"=>1056, "GQ"=>704, "ER"=>1056,
          "EE"=>1056, "ET"=>1056, "FO"=>704, "FJ"=>1056, "FI"=>1056, "FR"=>1056, "GF"=>1056, "PF"=>1056, "GA"=>1056, "GE"=>1056, "DE"=>1056,
          "GH"=>1056, "GB"=>1056, "GR"=>1056, "GD"=>1056, "GP"=>1056, "GT"=>1056, "GN"=>704, "GW"=>704, "GY"=>1056, "HT"=>1056, "HN"=>704,
          "HK"=>1056, "HU"=>1056, "IS"=>1056, "IN"=>1120, "ID"=>1056, "IQ"=>704, "IE"=>1056, "IL"=>704, "IT"=>1056, "JM"=>1056, "JP"=>1056,
          "JO"=>1056, "KZ"=>1056, "KE"=>1120, "KR"=>1056, "KW"=>1056, "KG"=>1056, "LA"=>1056, "LV"=>1056, "LS"=>1056, "LR"=>704, "LI"=>1056,
          "LT"=>1120, "LU"=>1056, "MO"=>1120, "MK"=>1056, "MG"=>1056, "MW"=>704, "MY"=>1056, "MV"=>1056, "ML"=>1056, "MT"=>704, "MQ"=>1056,
          "MR"=>1056, "MU"=>1056, "MX"=>704, "MD"=>1120, "MN"=>1056, "MA"=>68, "MZ"=>1056, "NA"=>352, "NR"=>704, "NP"=>69, "NL"=>1056,
          "AN"=>1056, "NC"=>1056, "NZ"=>1056, "NI"=>880, "NE"=>1120, "NG"=>1056, "NO"=>1056, "OM"=>1056, "PK"=>1056, "PA"=>1056, "PG"=>880,
          "PY"=>880, "PE"=>1120, "PH"=>704, "PL"=>704, "PT"=>1056, "QA"=>1056, "RO"=>1120, "RU"=>1120, "RW"=>1056, "KN"=>1056, "LC"=>704,
          "VC"=>704, "SM"=>1056, "SA"=>1056, "SN"=>1056, "RS"=>1056, "SC"=>1056, "SL"=>1056, "SG"=>1056, "SK"=>1056, "SI"=>1056, "SB"=>1056,
          "ZA"=>1056, "ES"=>1056, "LK"=>1056, "SD"=>1056, "SZ"=>1056, "SE"=>1056, "CH"=>1056, "SY"=>704, "TW"=>33, "TJ"=>1056, "TZ"=>1056,
          "TH"=>1056, "TG"=>1056, "TO"=>1056, "TT"=>1056, "TN"=>1056, "TR"=>1056, "TM"=>1056, "TC"=>1056, "UG"=>1056, "UA"=>704, "AE"=>1120,
          "UY"=>704, "UZ"=>1056, "VU"=>880, "VA"=>1056, "VE"=>1056, "VN"=>1056, "WS"=>704, "YE"=>1056, "ZM"=>1056, "ZW"=>704
        }

        def self.geo_group
          :international
        end

        def self.service_code
          "#{SERVICE_CODE_PREFIX[geo_group]}:1" #Priority Mail Express International™
        end

        def self.description
          I18n.t("usps.express_mail_international")
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
