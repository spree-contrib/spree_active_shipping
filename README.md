Active Shipping
===============

[![Build
Status](https://secure.travis-ci.org/spree/spree_active_shipping.png)](http://travis-ci.org/spree/spree_active_shipping)

This is a Spree extension that wraps the popular [active_shipping](http://github.com/Shopify/active_shipping/tree/master) plugin.

Installation
------------

We highly recommend using the stable branches of this gem. If you were using version 1.3, you can place this line inside your application's Gemfile:

```ruby
gem 'spree_active_shipping', :git => "git://github.com/spree/spree_active_shipping", :branch => "1-3-stable"
```

To install the latest edge version of this extension, place this line inside your application's Gemfile:

```ruby
gem 'spree_active_shipping', :git => "git://github.com/spree/spree_active_shipping"
```

Rate quotes from carriers
---

So far, this gem supports getting quotes from UPS, USPS, Canada Post, and FedEx. In general, you will need a developer account to get rates. Please contact the shipping vendor that you wish to use about generating a developer account.

Once you have an account, you can go to the active shipping settings admin configuration screen to set the right fields. You need to set all of the Orgin Address fields and the fields for the carrier you wish to use. To set the settings through a config file, you can assign values to the settings like so:

```ruby
Spree::ActiveShipping::Config[:origin_country]
Spree::ActiveShipping::Config[:origin_city]
Spree::ActiveShipping::Config[:origin_state]
Spree::ActiveShipping::Config[:origin_zip]
Spree::ActiveShipping::Config[:ups_login]
Spree::ActiveShipping::Config[:ups_password]
Spree::ActiveShipping::Config[:ups_key]
Spree::ActiveShipping::Config[:usps_login]
```

Global Handling Fee
-------------------

```ruby
Spree::ActiveShipping::Config[:handling_fee]
```

This property allows you to set a global handling fee that will be added to all calculated shipping rates.  Specify the number of cents, not dollars. You can either set it manually or through the admin interface.

Global Weight Default
---------------------

This property allows you to set a default weight that will be substituted for products lacking defined weights. You can either set it manually or through the admin interface.

```ruby
Spree::ActiveShipping::Config[:default_weight]
```

Installation
------------

1. Add the following to your applications Gemfile

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
