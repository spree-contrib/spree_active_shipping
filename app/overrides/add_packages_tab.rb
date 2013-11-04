Deface::Override.new(:virtual_path => "spree/admin/shared/_product_tabs",
                     :name => "add_product_packages_tab",
                     :insert_bottom => "[data-hook='admin_product_tabs']",
                     :text => "<li<%== ' class=\"active\"' if current == 'Product Packages' %>>
                       <%= link_to Spree.t(:product_packages), admin_product_product_packages_url(@product), :class => 'icon-barcode' %>
                     </li>")