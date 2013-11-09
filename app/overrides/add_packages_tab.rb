Deface::Override.new(:virtual_path => "spree/admin/shared/_product_tabs",
                     :name => "add_product_packages_tab",
                     :insert_bottom => "[data-hook='admin_product_tabs']",
                     :text => "<li<%== ' class=\"active\"' if current == 'Product Packages' %>>
                       <%= link_to_with_icon 'icon-truck', t(:product_packages), admin_product_product_packages_url(@product) %>
                     </li>")

