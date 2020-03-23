require 'spec_helper'
include ActiveShipping

module ActiveShipping
  describe Spree::ShippingCalculator do

    def build_content_items(variant, quantity, order)
      quantity.times.map {|i| Spree::Stock::ContentItem.new(build_inventory_unit(variant, order)) }
    end

    def build_inventory_unit(variant, order)
      build(:inventory_unit, variant: variant, order: order)
    end

    let(:country) { mock_model Spree::Country, :iso => "CA", :state_name => "Quebec", :state => nil }
    let(:address) { mock_model Spree::Address, :country => country, :state_name => country.state_name, :city => "Montreal", :zipcode => "H2B", :state => nil }
    let(:usa) { FactoryBot.create(:country, :name => "USA", :iso => "US") }
    let(:state) { FactoryBot.create(:state, country: usa, abbr: 'MD', name: 'Maryland')}
    let(:us_address) { FactoryBot.create(:address, :country => usa, :state => state, :city => "Chevy Chase", :zipcode => "20815") }
    let(:ca_order) { mock_model(Spree::Order, :ship_address => address) }
    let(:us_order) { mock_model(Spree::Order, :ship_address => us_address) }
    let(:package1) { mock_model(Spree::ProductPackage, :length => 12, :width => 24, :height => 47, :weight => 36) }
    let(:package2) { mock_model(Spree::ProductPackage, :length => 6, :width => 6, :height => 51, :weight => 43) }
    let(:variant1) { build(:variant, :weight => 20.0) }
    let(:variant2) { build(:variant, :weight => 5.25) }
    let(:variant3) { build(:variant, :weight => 29.0) }
    let(:variant4) { build(:variant, :weight => 100.0) }
    let(:variant5) { build(:variant, :weight => 0) }
    let(:variant6) { build(:variant, :weight => -1.0) }
    let(:variant7) { mock_model(Spree::Variant, :weight => 29.0, :product => mock_model(Spree::Product, :product_packages => [package1, package2])) }
    let(:variant8) { mock_model(Spree::Variant, :weight => 5.25, :product => mock_model(Spree::Product, :product_packages => [])) }
    let(:california) { FactoryBot.create(:state, country: usa, abbr: 'CA', name: 'California') }
    let(:stock_location) { FactoryBot.create(:stock_location, :address1 => '1313 S Harbor Blvd', :address2 => '', :city => 'Anaheim', :state => california, :country => usa, :phone => '7147814000', :active => 1) }

    let(:package) { double(Spree::Stock::Package,
          order: ca_order,
          contents: [build_content_items(variant1, 10, ca_order),
                    build_content_items(variant2, 4, ca_order),
                    build_content_items(variant3, 1, ca_order)].flatten) }

    let(:too_heavy_package) do
      Spree::Stock::Package.extend ActiveModel::Naming
      mock_model(
        Spree::Stock::Package,
        order: ca_order,
        stock_location: stock_location,
        contents: [
          build_content_items(variant3, 2, ca_order),
          build_content_items(variant4, 2, ca_order)
        ].flatten
      )
    end

    let(:us_package) { double(Spree::Stock::Package,
          order: ca_order,
          contents: [build_content_items(variant1, 10, ca_order),
                    build_content_items(variant2, 4, ca_order),
                    build_content_items(variant3, 1, ca_order)].flatten) }

    let(:package_with_invalid_weights) { double(Spree::Stock::Package,
          order: us_order,
          contents: [build_content_items(variant5, 1, us_order),
                    build_content_items(variant6, 1, us_order)].flatten) }

    let(:package_with_packages) { double(Spree::Stock::Package,
          order: us_order,
          contents: [build_content_items(variant8, 4, us_order),
                    build_content_items(variant7, 2, us_order)].flatten) }

    let(:international_calculator) {  Spree::Calculator::Shipping::Usps::PriorityMailInternational.new }
    let(:domestic_calculator) {  Spree::Calculator::Shipping::Usps::PriorityMail.new }

    before(:each) do
      Rails.cache.clear
      Spree::ActiveShipping::Config.set(:units => "imperial")
      Spree::ActiveShipping::Config.set(:unit_multiplier => 16)
      Spree::ActiveShipping::Config.set(:default_weight => 1)
    end

    def test_size_and_weight(packages:, size:, weights: [])
      expect(packages.size).to eq(size)
      # ActiveShipping ~> 2.0 dependency introduced a BREAKING CHANGE:
      # Use shopify/measured instead of shopify/quantified for dimensions and units.
      if ActiveRecord.version.release() < Gem::Version.new('5.2.0')
        # shopify/quantified
        expect(packages.map{|package| package.weight.amount}).to eq(weights.map{|x| x * Spree::ActiveShipping::Config[:unit_multiplier]})
        expect(packages.map{|package| package.weight.unit}.uniq).to eq([:ounces])
      else
        # shopify/meausured
        expect(packages.map{|package| package.weight.value}).to eq(weights.map{|x| x * Spree::ActiveShipping::Config[:unit_multiplier]})
        expect(packages.map{|package| package.weight.unit.name}.uniq).to eq(["oz"])
      end
    end

    describe "compute" do
      context "for international calculators" do
        it "should convert package contents to weights array for non-US countries (ex. Canada [limit = 66lbs])" do
          weights = international_calculator.send :convert_package_to_weights_array, package
          active_shipping_weights = [5.25, 5.25, 5.25, 5.25, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 29.0].map do |x|
            (x * Spree::ActiveShipping::Config[:unit_multiplier]).to_d
          end
          expect(weights).to match_array active_shipping_weights
        end

        it "should create array of packages" do
          packages = international_calculator.send :packages, package
          test_size_and_weight(
            packages: packages,
            size:     5,
            weights:  [61.0, 60.0, 60.0, 40.0, 29.0]
          )
        end

        context "raise exception if max weight exceeded" do
          it "should get Spree::ShippingError" do
            allow(too_heavy_package).to receive(:weight) do
              too_heavy_package.contents.sum{ |item| item.variant.weight * item.quantity }
            end
            expect { international_calculator.compute(too_heavy_package) }.to raise_error(Spree::ShippingError)
          end
        end
      end

      context "for domestic calculators" do
        it "should not convert order line items to weights array for US" do
          weights = domestic_calculator.send :convert_package_to_weights_array, us_package
          expect(weights).to eq([5.25, 5.25, 5.25, 5.25, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 29.0].map{|x| x * Spree::ActiveShipping::Config[:unit_multiplier]})
        end

        it "should create array with one package for US" do
          packages = domestic_calculator.send :packages, us_package
          test_size_and_weight(
            packages: packages,
            size:     4,
            weights:  [61.0, 60.0, 60.0, 69.0]
          )
        end
      end
    end

    describe "weight limits" do
      it "should be set for USPS calculators" do
        expect(international_calculator.send(:max_weight_for_country, country)).to eq(66.0 * Spree::ActiveShipping::Config[:unit_multiplier]) # Canada
        expect(domestic_calculator.send(:max_weight_for_country, country)).to eq(70.0 * Spree::ActiveShipping::Config[:unit_multiplier])
      end

      it "should respect the max weight per package" do
        Spree::ActiveShipping::Config.set(:max_weight_per_package => 30)
        weights = international_calculator.send :convert_package_to_weights_array, package
        expect(weights).to eq([5.25, 5.25, 5.25, 5.25, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 29.0].map{|x| x * Spree::ActiveShipping::Config[:unit_multiplier]})

        packages = international_calculator.send :packages, package
        test_size_and_weight(
          packages: packages,
          size:     12,
          weights:  [21.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 29.0]
        )
      end
    end

    describe "validation of line item weight" do
      it "should avoid zero weight or negative weight" do
        weights = domestic_calculator.send :convert_package_to_weights_array, package_with_invalid_weights
        default_weight = Spree::ActiveShipping::Config[:default_weight] * Spree::ActiveShipping::Config[:unit_multiplier]
        expect(weights).to eq([default_weight, default_weight])
      end
    end

    describe "validation of default weight of zero" do
      it "should accept zero default weight" do
        Spree::ActiveShipping::Config.set(:default_weight => 0)
        weights = domestic_calculator.send :convert_package_to_weights_array, package_with_invalid_weights
        expect(weights).to eq([0, 0])
      end
    end

    describe "adds item packages" do
      it "should add item packages to weight calculation" do
        packages = domestic_calculator.send :packages, package_with_packages
        test_size_and_weight(
          packages: packages,
          size:     6,
          weights:  [50, 29, 36, 43, 36, 43]
        )
      end
    end
  end
end
