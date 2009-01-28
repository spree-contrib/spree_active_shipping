# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class ActiveShippingExtension < Spree::Extension
  version "0.6.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/active_shipping"
  
  def activate
    # admin.tabs.add "Active Shipping", "/admin/active_shipping", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Active Shipping"
  end
  
end