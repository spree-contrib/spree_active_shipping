require 'spec_helper'
include ActiveMerchant::Shipping

module ActiveShipping
  describe Spree::Calculator do
  
    let(:country) { mock_model Spree::Country, :iso => "CA", :state_name => "Quebec", :state => nil }
    let(:address) { mock_model Spree::Address, :country => country, :state_name => country.state_name, :city => "Montreal", :zipcode => "H2B", :state => nil }
    let(:usa) { mock_model Spree::Country, :iso => "US", :state => mock_model(Spree::State, :abbr => "MD") }
    let(:us_address) { mock_model Spree::Address, :country => usa, :state => usa.state, :city => "Chevy Chase", :zipcode => "20815" }
    let(:line_item_1) { mock_model(Spree::LineItem, :variant_id => 1, :quantity => 10, :variant => mock_model(Spree::Variant, :weight => 20.0)) }
    let(:line_item_2) { mock_model(Spree::LineItem, :variant_id => 2, :quantity => 4, :variant => mock_model(Spree::Variant, :weight => 5.25)) }
    let(:line_item_3) { mock_model(Spree::LineItem, :variant_id => 3, :quantity => 1, :variant => mock_model(Spree::Variant, :weight => 29.0)) }
    let(:line_item_4) { mock_model(Spree::LineItem, :variant_id => 4, :quantity => 1, :variant => mock_model(Spree::Variant, :weight => 100.0)) }
    let(:line_item_5) { mock_model(Spree::LineItem, :variant_id => 5, :quantity => 1, :variant => mock_model(Spree::Variant, :weight => 0.0)) }
    let(:line_item_6) { mock_model(Spree::LineItem, :variant_id => 5, :quantity => 1, :variant => mock_model(Spree::Variant, :weight => -1.0)) }
    let(:order) { mock_model Spree::Order, :number => "R12345", :ship_address => address, :line_items =>  [ line_item_1, line_item_2, line_item_3 ] }
    let(:us_order) { mock_model Spree::Order, :number => "R12347", :ship_address => us_address, :line_items =>  [ line_item_1, line_item_2, line_item_3 ] }
    let(:too_heavy_order) { mock_model Spree::Order, :number => "R12349", :ship_address => us_address, :line_items =>  [ line_item_3, line_item_4 ] }
    let(:order_with_invalid_weights) { mock_model Spree::Order, :number => "R12350", :ship_address => us_address, :line_items =>  [ line_item_5, line_item_6 ] }
    
    
    let(:international_calculator) {  Spree::Calculator::Usps::PriorityMailInternational.new }
    let(:domestic_calculator) {  Spree::Calculator::Usps::PriorityMail.new }
    
    before(:each) do
      Rails.cache.clear
      Spree::ActiveShipping::Config.set(:units => "imperial")
      Spree::ActiveShipping::Config.set(:unit_multiplier => 16)
      Spree::ActiveShipping::Config.set(:default_weight => 1)
    end
    
    describe "compute" do
      context "for international calculators" do
        it "should convert order line items to weights array for non-US countries" do
          weights = international_calculator.send :convert_order_to_weights_array, order
          weights.should == [20.0, 21.0, 29.0, 60.0, 60.0, 60.0].map{|x| x*Spree::ActiveShipping::Config[:unit_multiplier]}
        end
        
        it "should create array of packages" do
          packages = international_calculator.send :packages, order
          packages.size.should == 4
          packages.map{|package| package.weight.amount}.should == [70.0, 60.0, 60.0, 60.0].map{|x| x*Spree::ActiveShipping::Config[:unit_multiplier]}
          packages.map{|package| package.weight.unit}.uniq.should == [:ounces]
        end
        
        context "raise exception if max weight exceeded" do
          it "should get Spree::ShippingError" do
            expect { international_calculator.compute(too_heavy_order) }.to raise_error(Spree::ShippingError)
          end
        end
      end
         
      context "for domestic calculators" do
        it "should not convert order line items to weights array for US" do
          weights = domestic_calculator.send :convert_order_to_weights_array, us_order
          weights.should == [20.0, 21.0, 29.0, 60.0, 60.0, 60.0].map{|x| x*Spree::ActiveShipping::Config[:unit_multiplier]}
        end
        
        it "should create array with one package for US" do
          packages = domestic_calculator.send :packages, us_order
          packages.size.should == 4
          packages.map{|package| package.weight.amount}.should == [70.0, 60.0, 60.0, 60.0].map{|x| x*Spree::ActiveShipping::Config[:unit_multiplier]}
          packages.map{|package| package.weight.unit}.uniq.should == [:ounces]
        end
      end
    end
    
    describe "weight limits" do
      it "should be set for USPS calculators" do
        international_calculator.send(:max_weight_for_country, country).should == 70.0*Spree::ActiveShipping::Config[:unit_multiplier]
        domestic_calculator.send(:max_weight_for_country, country).should == 70.0*Spree::ActiveShipping::Config[:unit_multiplier]
      end
    end
    
    describe "validation of line item weight" do
      it "should avoid zero weight or negative weight" do
        weights = domestic_calculator.send :convert_order_to_weights_array, order_with_invalid_weights
        default_weight = Spree::ActiveShipping::Config[:default_weight] * Spree::ActiveShipping::Config[:unit_multiplier]
        weights.should == [default_weight, default_weight]
      end
    end
  end
end
