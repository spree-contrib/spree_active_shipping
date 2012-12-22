Deface::Override.new(:virtual_path => "spree/admin/configurations/index",
                     :name => "add_active_shipping_settings_link",
                     :insert_after => "[data-hook='admin_configurations_menu'], #admin_configurations_menu[data-hook]",
                     :text => "<tr>
      <td><%= link_to \"Active Shipping\", admin_active_shipping_settings_path %></td>
      <td><%= \"Configure Active Shipping Settings\" %></td>
      </tr>")
