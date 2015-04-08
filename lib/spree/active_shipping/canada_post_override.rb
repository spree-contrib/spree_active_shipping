module Spree
  module ActiveShipping
    # Override to fix a bug with readToShip : sending ready_to_ship: nil will
    # add a <readyToShip/> tag, which means true. The solution is to not
    # include the tag.
    module CanadaPostOverride
      def self.included(base)

        base.class_eval do

          # <!-- List of items in the shopping    -->
          # <!-- cart                             -->
          # <!-- Each item is defined by :        -->
          # <!--   - quantity    (mandatory)      -->
          # <!--   - size        (mandatory)      -->
          # <!--   - weight      (mandatory)      -->
          # <!--   - description (mandatory)      -->
          # <!--   - ready to ship (optional)     -->
          
          def build_line_items(line_items)
            xml_builder = Nokogiri::XML::Builder.new do |xml|
              xml.lineItems do

                line_items.each do |line_item|
                  xml.item do
                    xml.quantity(1) 
                    xml.weight(line_item.kilograms)
                    xml.length(line_item.cm(:length).to_s)
                    xml.width(line_item.cm(:width).to_s)
                    xml.height(line_item.cm(:height).to_s)
                    xml.description(line_item.options[:description] || ' ')
                    xml.readyToShip if line_item.options[:ready_to_ship] # SPREE OVERRIDE
                    
                    # By setting the 'readyToShip' tag to true, Sell Online will not pack this item in the boxes defined in the merchant profile.
                  end
                end
              end
            end
            
            xml_builder.to_xml
          end

        end

      end
    end
  end
end

