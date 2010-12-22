require File.dirname(__FILE__) + '/../spec_helper'
include ActiveMerchant::Shipping

module ActiveShipping
  describe Calculator do
    # NOTE: All specs will use the bogus calculator (no login information needed)

    let(:country) { mock_model Country, :iso => "US", :state => mock_model(State, :abbr => "MD") }
    let(:address) { mock_model Address, :country => country, :state => country.state, :city => "Chevy Chase", :zipcode => "20815" }
    let(:line_item_1) { mock_model(LineItem, :variant_id => 1, :quantity => 2, :variant => mock_model(Variant, :weight => 10)) }
    let(:line_item_2) { mock_model(LineItem, :variant_id => 2, :quantity => 1, :variant => mock_model(Variant, :weight => 5.25)) }
    let(:order) { mock_model Order, :number => "R12345", :ship_address => address, :line_items =>  [ line_item_1, line_item_2 ] }

    let(:carrier) { Spree::ActiveShipping::BogusCarrier.new }
    let(:calculator) {  Spree::ActiveShipping::BogusCalculator.new }

    before(:each) do
      Spree::ActiveShipping::Config.set(:units => "imperial")
      Spree::ActiveShipping::Config.set(:unit_multiplier => 16)

      calculator.stub!(:carrier).and_return(carrier)
      Rails.cache.clear
    end

    describe "compute" do
      it "should use the carrier supplied in the initializer" do
        carrier.should_receive(:find_rates).and_return(ActiveMerchant::Shipping::RateResponse.new(true, "Foo"))
        calculator.compute(order)
      end
      it "should multiply the weight by the line item quantity" do
        line_item_1.should_receive(:quantity).and_return(2)
        calculator.compute(order)
      end
      it "should ignore variants that have a nil weight" do
        line_item_1.variant.stub(:weight => nil)
        calculator.compute(order)
      end
      it "should create a package with the correct total weight in ounces" do
        # (10 * 2 + 5.25 * 1) * 16 = 404
        Package.should_receive(:new).with(404, [], :units => :imperial)
        calculator.compute(order)
      end
      it "should check the cache first before finding rates" do
        Rails.cache.fetch(calculator.send(:cache_key, order)) { Hash.new }
        carrier.should_not_receive(:find_rates)
        calculator.compute(order)
      end
    end
end

end
