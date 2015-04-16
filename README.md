Active Shipping
===============

[![Build Status](https://travis-ci.org/spree-contrib/spree_active_shipping.svg?branch=2-4-stable)](https://travis-ci.org/spree-contrib/spree_active_shipping)

This is a Spree extension that wraps the popular [active_shipping](http://github.com/Shopify/active_shipping/tree/master) plugin.

Installation
------------

**1.** Add the gem to your application's Gemfile:

We highly recommend using the stable branches of this gem. If you were using version 1.3, you can place this line inside your application's Gemfile:

```ruby
gem 'spree_active_shipping', :git => "git://github.com/spree/spree_active_shipping", :branch => "1-3-stable"
```

To install the latest edge version of this extension, place this line inside your application's Gemfile:

- To use the latest edge code in master branch:

```ruby
gem 'spree_active_shipping', :git => "git://github.com/spree/spree_active_shipping"
```

- To use a specific branch specified in the Versionfile for your version of Spree:

```ruby
gem 'spree_active_shipping', :git => "git://github.com/spree/spree_active_shipping", :branch => '1-3-stable'
```

**2.** Install migrations and migrate database:

```
$ bundle exec rake railties:install:migrations
$ bundle exec rake db:migrate
```

**3.** Run bundler:

```
$ bundle
```

Rate quotes from carriers
---

So far, this gem supports getting quotes from UPS, USPS, Canada Post, and FedEx. In general, you will need a developer account to get rates. Please contact the shipping vendor that you wish to use about generating a developer account.

Once you have an account, you can go to the active shipping settings admin configuration screen to set the right fields. You need to set all of the Origin Address fields and the fields for the carrier you wish to use. To set the settings through a config file, you can assign values to the settings like so:

```ruby
Spree::ActiveShipping::Config[:ups_login]
Spree::ActiveShipping::Config[:ups_password]
Spree::ActiveShipping::Config[:ups_key]
Spree::ActiveShipping::Config[:usps_login]
```

**NOTE:** When setting up FedEx credentials, `:fedex_login` is the "Meter Number" that FedEx supplies you with.

It is important to note how this wrapper matches the calculators to the services available from the carrier API's, by default the base calculator matches the service name to the calculator class and returns the rate, this magic happens as follows:

1. inside the calculator class
```ruby
Spree::Calculator::Shipping::Fedex::GroundHomeDelivery::description #holds the service name
```

2. inside the calculator base
```ruby
  rates_result = retrieve_rates_from_cache(package, origin, destination) # <- holds the rates for given package in a parsed hash (see sample response below)
  rate = rates_result[self.class.description] # <- matches with the description as the key
```

this means that the calculator **Fedex::GroundHomeDelivery** will hit FedEx Servers and try to get the rates for the given package, since FedEx returns rates for package and returns all of its available services for the given shipment we need to identify which service we are targeting ( see caching results below ) the calculator will only pick the rates from a service that matches the **"FedEx Ground Home Delivery"** string, you can see how it works below:

a sample rate response already parsed looks like this:
```ruby
{
         "FedEx First Overnight" => 5886,
      "FedEx Priority Overnight" => 2924,
      "FedEx Standard Overnight" => 2529,
                "FedEx 2 Day Am" => 1987,
                   "FedEx 2 Day" => 1774,
    "FedEx Ground Home Delivery" => 925
}
```

the rate hash that is parsed by the calculator has service descriptions as keys, this makes it easier to get the rates you need.

3. getting the rates (all the above together)
```ruby
  calculator = Spree::Calculator::Shipping::Fedex::GroundHomeDelivery.new
  calculator.description # "FedEx Ground Home Delivery"
  rate = calculator.compute(<Package>)
  rate # $9.25
```

you can see the rates are given in cents from FedEx (in the rate hash example above), ```spree_active_shipping``` converts them dividing them by 100 before sending them to you

**Note:** if you want to integrate to a new carrier service that is not listed below please take care when trying to match the service name key to theirs, there are times when they create dynamic naming conventions, please take as an example **USPS**, you can see the implementation of USPS has the **compute_packages** method overridden to match against a **service_code** key that had to be added to calculator services ( Issue #103 )

Global Handling Fee
-------------------

```ruby
Spree::ActiveShipping::Config[:handling_fee]
```

This property allows you to set a global handling fee that will be added to all calculated shipping rates.  Specify the number of cents, not dollars. You can either set it manually or through the admin interface.

Weights
---------------------

## Global weight default
This property allows you to set a default weight that will be substituted for products lacking defined weights. You can either set it manually or through the admin interface.

```ruby
Spree::ActiveShipping::Config[:default_weight]
```

## Weight units
Weights are expected globally inside ```spree_active_shipping``` to be entered in a unit that can be divided to oz and a global variable was added to help with unit conversion

```ruby
Spree::ActiveShipping::Config[:unit_multiplier]
```

It is important to note that by default this variable is set to have a value of **16** expecting weights to be entered in **lbs**

### Example of converting from metric system to oz

Say you have your weights in **kg** you would have to set the multiplier to **0.0283495**

```ruby
Spree::ActiveShipping::Config[:unit_multiplier] = 0.0283495
```

Cache
------------

When Spree tries to get rates for a given shipment it calls **Spree::Stock::Estimator**, this class is in charge of getting the rates back from any calculator active for a shipment, the way the estimator determines the shipping methods that will apply to the shipment varies from within spree versions but the general idea is this:

**NOTE:** Shipping methods are tied to calculators

```ruby
  private
  def shipping_methods(package)
    shipping_methods = package.shipping_methods
    shipping_methods.delete_if { |ship_method| !ship_method.calculator.available?(package) }
    shipping_methods.delete_if { |ship_method| !ship_method.include?(order.ship_address) }
    shipping_methods.delete_if { |ship_method| !(ship_method.calculator.preferences[:currency].nil? || ship_method.calculator.preferences[:currency] == currency) }
    shipping_methods
  end
```

The money line for **spree_active_shipping** is when it calls the calculator's ```available?``` method, this method is actually calling the carrier services, and it checks for rates or errors in the form of ```Spree::ShippingError```, if the rates are there for the specified shipment, the calculator will store the parsed rates with a specific key for each package inside the cache, consider the following example to see why this works and why this is necessary:

- User orders N amount of products
- All of the products from this order are stored in Stock Location 1
- Once the order creates shipments you will end up with 1 shipment
- Calculators are active for the following services: **FedEx Ground Home Delivery**, **FedEx 2 Day**, **FedEx International Priority**
- Order calls the estimator for rates:
- Estimator will try to get the active shipping methods for this package, it will call available? on all of the active calculators to determine if they are all available for this shipment
- once it calls it for the first calculator (**FedEx Ground Home Delivery**) it will get the following rates back from FedEx

```ruby
{
         "FedEx First Overnight" => 5886,
      "FedEx Priority Overnight" => 2924,
      "FedEx Standard Overnight" => 2529,
                "FedEx 2 Day Am" => 1987,
                   "FedEx 2 Day" => 1774,
    "FedEx Ground Home Delivery" => 925
}
```

- when it tries to get rates for the 2nd calculator (**FedEx 2 Day**) it will check the cache first and will find that for this package and stock location it already has rates stored in the cache and it won't call FedEx again, using this same rates
- when it hits the last calculator (**FedEx International Priority**) it will find that the cache doesn't have any rates for the given key, and the method ```available?``` called from the Estimator will return false thus removing the calculator's shipping method from the list of available calculators and won't return any rates back for it
- Consequently since this 3rd calculator (**FedEx International Priority**) is an international calculator it would have been removed as well by the line that checks if any shipping method is allowed in already defined Zones.

Installation
------------

1. Add the following to your application's Gemfile

```ruby
gem 'spree_active_shipping'
```

2. Run bundler

```
bundle install
```

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Further Reading
---------------

Andrea Singh has also written an excellent [blog post](http://blog.madebydna.com/all/code/2010/05/26/setting-up-usps-shipping-with-spree.html) covering the use of this extension in detail. It is rather old and somewhat outdated.
