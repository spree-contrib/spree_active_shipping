Active Shipping
===============

This is a Spree extension that wraps the popular [active_shipping](http://github.com/Shopify/active_shipping/tree/master) plugin.

UPS 
---

You will need a UPS developer account to get rate quotes (even in development and test mode.)  The UPS calculators also require that you set the following configuration properties. You will also need a USPS account to use USPS rate quote system. Note: acquiring the USPS developer account is easy but has a confusion activation step. Look for related sicussion in ActiveShipping's original discussion group as well as carefully read your USPS confirmation email. 

<pre>
Spree::ActiveShipping::Config[:origin_country]
Spree::ActiveShipping::Config[:origin_city]
Spree::ActiveShipping::Config[:origin_state]
Spree::ActiveShipping::Config[:origin_zip]
Spree::ActiveShipping::Config[:ups_login]
Spree::ActiveShipping::Config[:ups_password]
Spree::ActiveShipping::Config[:ups_key]
Spree::ActiveShipping::Config[:usps_login]
</pre>

It will soon be possible to set these properties through a new admin configuration screen (even sooner if someone else writes the patch!)  

Global Handling Fee
-------------------

<pre>
Spree::ActiveShipping::Config[:handling_fee]
</pre>

This property allows you to set a global handling fee that will be added to all calculated shipping rates.  Specify the number of cents, not dollars.

Using Migrations
----------------

If you'd like to set your shipping configuration as part of a migration you could add something like this to your site extension.

<pre>
class AddUpsConfiguration < ActiveRecord::Migration
  def self.up
    Spree::ActiveShipping::Config.set(:ups_login => "dpbrowning")
    Spree::ActiveShipping::Config.set(:ups_password => "doublewide")
    Spree::ActiveShipping::Config.set(:ups_key => "5B8DDE509EFDA5D6")
    Spree::ActiveShipping::Config.set(:usps_login => "13658997AOE2568XOE")
  end

  def self.down
  end
end
</pre> 

Further Reading
---------------

Andrea Singh has also written an excellent [blog post](http://blog.madebydna.com/all/code/2010/05/26/setting-up-usps-shipping-with-spree.html) covering the use of this extension in detail.
