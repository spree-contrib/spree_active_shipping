require 'spec_helper'
include ActiveMerchant::Shipping

module ActiveShipping
  describe Spree::ShippingCalculator do

    let(:country) { mock_model Spree::Country, :iso => "CA", :state_name => "Quebec", :state => nil }
    let(:address) { mock_model Spree::Address, :country => country, :state_name => country.state_name, :city => "Montreal", :zipcode => "H2B", :state => nil }
    let(:usa) { FactoryGirl.create(:country, :name => "USA", :iso => "US") }
    let(:state) { FactoryGirl.create(:state, country: usa, abbr: 'MD', name: 'Maryland')}
    let(:us_address) { FactoryGirl.create(:address, :country => usa, :state => state, :city => "Chevy Chase", :zipcode => "20815") }
    let(:package1) { mock_model(Spree::ProductPackage, :length => 12, :width => 24, :height => 47, :weight => 36) }
    let(:package2) { mock_model(Spree::ProductPackage, :length => 6, :width => 6, :height => 51, :weight => 43) }
    let(:variant1) { build(:variant, :weight => 20.0) }
    let(:variant2) { build(:variant, :weight => 5.25) }
    let(:variant3) { build(:variant, :weight => 29.0) }
    let(:variant4) { build(:variant, :weight => 100.0) }
    let(:variant5) { build(:variant, :weight => 0) }
    let(:variant6) { build(:variant, :weight => -1.0) }
    let(:variant7) { double(Spree::Variant, :weight => 29.0, :product => mock_model(Spree::Product, :product_packages => [package1, package2])) }
    let(:variant8) { double(Spree::Variant, :weight => 5.25, :product => mock_model(Spree::Product, :product_packages => [])) }
    let(:california) { FactoryGirl.create(:state, country: usa, abbr: 'CA', name: 'California') }
    let(:stock_location) { FactoryGirl.create(:stock_location, :address1 => '1313 S Harbor Blvd', :address2 => '', :city => 'Anaheim', :state => california, :country => usa, :phone => '7147814000', :active => 1) }
    let(:package) { double(Spree::Stock::Package,
          order: mock_model(Spree::Order, :ship_address => address),
          contents: [Spree::Stock::Package::ContentItem.new(nil, variant1, 10),
                    Spree::Stock::Package::ContentItem.new(nil, variant2, 4),
                    Spree::Stock::Package::ContentItem.new(nil, variant3, 1)]) }
    let(:too_heavy_package) { double(Spree::Stock::Package,
          order: mock_model(Spree::Order, :ship_address => address),
          stock_location: stock_location,
          contents: [Spree::Stock::Package::ContentItem.new(nil, variant3, 2),
                    Spree::Stock::Package::ContentItem.new(nil, variant4, 2)]) }
    let(:us_package) { double(Spree::Stock::Package,
          order: mock_model(Spree::Order, :ship_address => us_address),
          contents: [Spree::Stock::Package::ContentItem.new(nil, variant1, 10),
                    Spree::Stock::Package::ContentItem.new(nil, variant2, 4),
                    Spree::Stock::Package::ContentItem.new(nil, variant3, 1)]) }
    let(:package_with_invalid_weights) { double(Spree::Stock::Package,
          order: mock_model(Spree::Order, :ship_address => us_address),
          contents: [Spree::Stock::Package::ContentItem.new(nil, variant5, 1),
                    Spree::Stock::Package::ContentItem.new(nil, variant6, 1)]) }
    let(:package_with_packages) { double(Spree::Stock::Package,
          order: mock_model(Spree::Order, :ship_address => us_address),
          contents: [Spree::Stock::Package::ContentItem.new(nil, variant8, 4),
                    Spree::Stock::Package::ContentItem.new(nil, variant7, 2)]) }
    let(:international_calculator) {  Spree::Calculator::Shipping::Usps::PriorityMailInternational.new }
    let(:domestic_calculator) {  Spree::Calculator::Shipping::Usps::PriorityMail.new }

    before(:each) do
      Rails.cache.clear
      Spree::ActiveShipping::Config.set(:units => "imperial")
      Spree::ActiveShipping::Config.set(:unit_multiplier => 16)
      Spree::ActiveShipping::Config.set(:default_weight => 1)
    end

    describe "compute" do
      context "for international calculators" do
        it "should convert package contents to weights array for non-US countries (ex. Canada [limit = 66lbs])" do
          weights = international_calculator.send :convert_package_to_weights_array, package
          weights.should == [20.0, 21.0, 29.0, 60.0, 60.0, 60.0].map{|x| x * Spree::ActiveShipping::Config[:unit_multiplier]}
        end

        it "should create array of packages" do
          packages = international_calculator.send :packages, package
          packages.size.should == 5
          packages.map{|package| package.weight.amount}.should == [41.0, 29.0, 60.0, 60.0, 60.0].map{|x| x * Spree::ActiveShipping::Config[:unit_multiplier]}
          packages.map{|package| package.weight.unit}.uniq.should == [:ounces]
        end

        context "raise exception if max weight exceeded" do
          it "should get Spree::ShippingError" do
            too_heavy_package.stub(:weight) do
              too_heavy_package.contents.sum{ |item| item.variant.weight * item.quantity }
            end
            expect { international_calculator.compute(too_heavy_package) }.to raise_error(Spree::ShippingError)
          end
        end
      end

      context "for domestic calculators" do
        it "should not convert order line items to weights array for US" do
          weights = domestic_calculator.send :convert_package_to_weights_array, us_package
          weights.should == [20.0, 21.0, 29.0, 60.0, 60.0, 60.0].map{|x| x * Spree::ActiveShipping::Config[:unit_multiplier]}
        end

        it "should create array with one package for US" do
          packages = domestic_calculator.send :packages, us_package
          packages.size.should == 4
          packages.map{|package| package.weight.amount}.should == [70.0, 60.0, 60.0, 60.0].map{|x| x * Spree::ActiveShipping::Config[:unit_multiplier]}
          packages.map{|package| package.weight.unit}.uniq.should == [:ounces]
        end
      end
    end

    describe "weight limits" do
      it "should be set for USPS calculators" do
        international_calculator.send(:max_weight_for_country, country).should == 66.0 * Spree::ActiveShipping::Config[:unit_multiplier] # Canada
        domestic_calculator.send(:max_weight_for_country, country).should == 70.0 * Spree::ActiveShipping::Config[:unit_multiplier]
      end

      it "should respect the max weight per package" do
        Spree::ActiveShipping::Config.set(:max_weight_per_package => 30)
        weights = international_calculator.send :convert_package_to_weights_array, package
        weights.should == [20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 21.0, 29.0].map{|x| x * Spree::ActiveShipping::Config[:unit_multiplier]}

        packages = international_calculator.send :packages, package
        packages.size.should == 12
        packages.map{|package| package.weight.amount}.should == [20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 21.0, 29.0].map{|x| x * Spree::ActiveShipping::Config[:unit_multiplier]}
        packages.map{|package| package.weight.unit}.uniq.should == [:ounces]
      end
    end

    describe "validation of line item weight" do
      it "should avoid zero weight or negative weight" do
        weights = domestic_calculator.send :convert_package_to_weights_array, package_with_invalid_weights
        default_weight = Spree::ActiveShipping::Config[:default_weight] * Spree::ActiveShipping::Config[:unit_multiplier]
        weights.should == [default_weight, default_weight]
      end
    end

    describe "validation of default weight of zero" do
      it "should accept zero default weight" do
        Spree::ActiveShipping::Config.set(:default_weight => 0)
        weights = domestic_calculator.send :convert_package_to_weights_array, package_with_invalid_weights
        weights.should == [0, 0]
      end
    end

    describe "adds item packages" do
      it "should add item packages to weight calculation" do
        packages = domestic_calculator.send :packages, package_with_packages
        packages.size.should == 6
        packages.map{|package| package.weight.amount}.should == [21, 58, 36, 36, 43, 43].map{|x| x * Spree::ActiveShipping::Config[:unit_multiplier]}
        packages.map{|package| package.weight.unit}.uniq.should == [:ounces]
      end
    end
  end
end
