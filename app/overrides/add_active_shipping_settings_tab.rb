Deface::Override.new(:virtual_path => "spree/admin/shared/_configuration_menu",
                     :name => "add_active_shipping_settings_link",
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu'], #admin_configurations_sidebar_menu[data-hook]",
                     :text => "<%= configurations_sidebar_menu_item t(:active_shipping_settings), edit_admin_active_shipping_settings_path %>")
