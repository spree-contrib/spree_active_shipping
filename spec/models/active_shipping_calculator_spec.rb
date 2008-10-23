require File.dirname(__FILE__) + '/../spec_helper'
include ActiveMerchant::Shipping

describe ActiveShippingCalculator do
  
  # NOTE: All specs will use the bogus calculator (no login information needed)
  before(:each) do
    @calculator = ActiveShippingCalculator.new(ActiveMerchant::Shipping::BogusCarrier)
    Spree::ActiveShipping::Config.set(:units => "imperial")
    Spree::ActiveShipping::Config.set(:unit_multiplier => 16)
    v1 = Variant.new(:weight => 10)
    v2 = Variant.new(:weight => 5.25)
    @line_item1 = LineItem.new(:variant => v1, :quantity => 2)
    @line_item2 = LineItem.new(:variant => v2, :quantity => 1)
    
    @address = Address.new(:country => Country.new(:iso => "US"), :state => State.new(:abbr => "NY"))
    @order = Order.new(:line_items => [@line_item1, @line_item2], :address => @address)
  end

  describe "calculate_shipping" do
    it "should use the carrier supplied in the initializer" do
      bogus_carrier = mock("Bogus Carrier")
      bogus_carrier.should_receive(:find_rates)
      ActiveMerchant::Shipping::BogusCarrier.stub!(:new).and_return(bogus_carrier)
      @calculator = ActiveShippingCalculator.new(ActiveMerchant::Shipping::BogusCarrier)
      @calculator.calculate_shipping(@order)
    end
    it "should multiply the weight by the line item quantity" do
      @line_item1.should_receive(:quantity).and_return(2)
      @calculator.calculate_shipping(@order)
    end
    it "should create a package with the correct total weight in ounces" do
      #expected_weight = BigDecimal.new("404") # (10 * 2 + 5.25 * 1) * 16
      Package.should_receive(:new).with(404, [], :units => :imperial)
      @calculator.calculate_shipping(@order) 
    end
  end
end