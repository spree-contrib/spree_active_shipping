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
            xml_line_items = XmlNode.new('lineItems') do |line_items_node|
              
              line_items.each do |line_item|
                
                line_items_node << XmlNode.new('item') do |item|
                  item << XmlNode.new('quantity', 1) 
                  item << XmlNode.new('weight', line_item.kilograms)
                  item << XmlNode.new('length', line_item.cm(:length).to_s)
                  item << XmlNode.new('width', line_item.cm(:width).to_s)
                  item << XmlNode.new('height', line_item.cm(:height).to_s)
                  item << XmlNode.new('description', line_item.options[:description] || ' ')
                  # Only this line got changed
                  item << XmlNode.new('readyToShip') if line_item.options[:ready_to_ship]
                  
                  # By setting the 'readyToShip' tag to true, Sell Online will not pack this item in the boxes defined in the merchant profile.
                end
              end
            end
            
            xml_line_items
          end
        end
      end
    end
  end
end

