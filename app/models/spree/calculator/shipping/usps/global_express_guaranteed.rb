module Spree
  module Calculator::Shipping
    module Usps
      class GlobalExpressGuaranteed < Spree::Calculator::Shipping::Usps::Base
        # http://pe.usps.com/text/imm/ab_001.htm .. http://pe.usps.com/text/imm/tz_028.htm
        WEIGHT_LIMITS = {
          "AD"=>64,
          "CD"=>1056,
          "AE"=>1120, "AF"=>1120, "AG"=>1120, "AI"=>1120, "AL"=>1120, "AM"=>1120, "AN"=>1120, "AO"=>1120, "AR"=>1120, "AT"=>1120, "AU"=>1120,
          "AW"=>1120, "AZ"=>1120, "BA"=>1120, "BB"=>1120, "BD"=>1120, "BE"=>1120, "BF"=>1120, "BG"=>1120, "BH"=>1120, "BI"=>1120, "BJ"=>1120,
          "BM"=>1120, "BN"=>1120, "BR"=>1120, "BS"=>1120, "BT"=>1120, "BW"=>1120, "BY"=>1120, "BZ"=>1120, "CA"=>1120, "CG"=>1120, "CH"=>1120,
          "CI"=>1120, "CL"=>1120, "CM"=>1120, "CN"=>1120, "CO"=>1120, "CR"=>1120, "CV"=>1120, "CY"=>1120, "CZ"=>1120, "DE"=>1120, "DJ"=>1120,
          "DK"=>1120, "DM"=>1120, "DO"=>1120, "DZ"=>1120, "EC"=>1120, "EE"=>1120, "EG"=>1120, "ER"=>1120, "ES"=>1120, "ET"=>1120, "FI"=>1120,
          "FJ"=>1120, "FO"=>1120, "FR"=>1120, "GA"=>1120, "GB"=>1120, "GD"=>1120, "GE"=>1120, "GF"=>1120, "GH"=>1120, "GI"=>1120, "GL"=>1120,
          "GM"=>1120, "GN"=>1120, "GP"=>1120, "GR"=>1120, "GT"=>1120, "GY"=>1120, "HK"=>1120, "HN"=>1120, "HR"=>1120, "HT"=>1120, "HU"=>1120,
          "ID"=>1120, "IE"=>1120, "IL"=>1120, "IN"=>1120, "IQ"=>1120, "IS"=>1120, "IT"=>1120, "JM"=>1120, "JO"=>1120, "JP"=>1120, "KE"=>1120,
          "KG"=>1120, "KH"=>1120, "KM"=>1120, "KN"=>1120, "KR"=>1120, "KW"=>1120, "KY"=>1120, "KZ"=>1120, "LA"=>1120, "LB"=>1120, "LC"=>1120,
          "LI"=>1120, "LK"=>1120, "LR"=>1120, "LS"=>1120, "LT"=>1120, "LU"=>1120, "LV"=>1120, "LY"=>1120, "MA"=>1120, "MD"=>1120, "ME"=>1120,
          "MG"=>1120, "MK"=>1120, "ML"=>1120, "MN"=>1120, "MO"=>1120, "MP"=>1120, "MQ"=>1120, "MR"=>1120, "MS"=>1120, "MT"=>1120, "MU"=>1120,
          "MV"=>1120, "MW"=>1120, "MX"=>1120, "MY"=>1120, "MZ"=>1120, "NA"=>1120, "NC"=>1120, "NE"=>1120, "NG"=>1120, "NI"=>1120, "NL"=>1120,
          "NO"=>1120, "NP"=>1120, "NZ"=>1120, "OM"=>1120, "PA"=>1120, "PE"=>1120, "PF"=>1120, "PG"=>1120, "PH"=>1120, "PK"=>1120, "PL"=>1120,
          "PT"=>1120, "PY"=>1120, "QA"=>1120, "RE"=>1120, "RO"=>1120, "RS"=>1120, "RU"=>1120, "RW"=>1120, "SA"=>1120, "SC"=>1120, "SE"=>1120,
          "SG"=>1120, "SI"=>1120, "SK"=>1120, "SM"=>1120, "SN"=>1120, "SR"=>1120, "SV"=>1120, "SZ"=>1120, "TC"=>1120, "TD"=>1120, "TG"=>1120,
          "TH"=>1120, "TN"=>1120, "TO"=>1120, "TR"=>1120, "TT"=>1120, "TW"=>1120, "TZ"=>1120, "UA"=>1120, "UG"=>1120, "UY"=>1120, "UZ"=>1120,
          "VA"=>1120, "VC"=>1120, "VE"=>1120, "VG"=>1120, "VN"=>1120, "VU"=>1120, "WF"=>1120, "YE"=>1120, "ZA"=>1120, "ZM"=>1120, "ZW"=>1120
        }

        def self.geo_group
          :international
        end

        def self.service_code
          "#{SERVICE_CODE_PREFIX[geo_group]}:4" #Global Express Guaranteed
        end

        def self.description
          I18n.t("usps.global_express_guaranteed")
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
