Active Shipping
===============

This is a Spree extension that wraps the popular [active_shipping](http://github.com/Shopify/active_shipping/tree/master) plugin.

UPS 
---

You will need a UPS developer account to get rate quotes (even in development and test mode.)  The UPS calculators also require that you set the following configuration properties.

<pre>
Spree::ActiveShipping::Config[:origin_country]
Spree::ActiveShipping::Config[:origin_city]
Spree::ActiveShipping::Config[:origin_state]
Spree::ActiveShipping::Config[:origin_zip]
Spree::ActiveShipping::Config[:ups_login]
Spree::ActiveShipping::Config[:ups_password]
Spree::ActiveShipping::Config[:ups_key]
</pre>

It will soon be possible to set these properties through a new admin configuration screen (even sooner if someone else writes the patch!)  

If you'd like to set your shipping configuration as part of a migration you could add something like this to your site extension.

<pre>
class AddUpsConfiguration < ActiveRecord::Migration
  def self.up
    Spree::ActiveShipping::Config.set(:ups_login => "dpbrowning")
    Spree::ActiveShipping::Config.set(:ups_password => "doublewide")
    Spree::ActiveShipping::Config.set(:ups_key => "5B8DDE509EFDA5D6")
  end

  def self.down
  end
end
</pre>