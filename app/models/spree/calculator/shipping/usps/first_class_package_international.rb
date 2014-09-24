module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassPackageInternational < Spree::Calculator::Shipping::Usps::Base
        def self.geo_group
          :international
        end

        def self.service_code
          "#{SERVICE_CODE_PREFIX[geo_group]}:15" # First-Class Package International Service™
        end

        def self.description
          I18n.t("usps.first_class_package_international")
        end

        protected
        # weight limit in ounces or zero (if there is no limit)
        def max_weight_for_country(country)
          64  # See limit of 4 pounds below.
        end

        # SAMPLE API RESPONSE
        #  Pulled 21-Nov-2013
        #{
        #"ID": "15",
        #"Pounds": "0",
        #"Ounces": "11",
        #"MailType": "Package",
        #"Container": "RECTANGULAR",
        #"Size": "REGULAR",
        #"Width": "0.01",
        #"Length": "0.01",
        #"Height": "0.01",
        #"Girth": "0.01",
        #"Country": "SPAIN",
        #"Postage": "14.90",
        #"ExtraServices": null,
        #"ValueOfContents": "0.00",
        #"InsComment": "SERVICE",
        #"SvcCommitments": "Varies by destination",
        #"SvcDescription": "First-Class Package International Service&lt;sup&gt;&#8482;&lt;/sup&gt;**",
        #"MaxDimensions": "Other than rolls: Max. length 24\", max length, height and depth (thickness) combined 36\"<br>Rolls: Max. length 36\". Max length and twice the diameter combined 42\"",
        #"MaxWeight": "4"
        #}
      end
    end
  end
end
