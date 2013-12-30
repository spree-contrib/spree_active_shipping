require 'spec_helper'
include ActiveMerchant::Shipping

module ActiveShipping
  describe Spree::Calculator::Shipping do
    WebMock.disable_net_connect!
    # NOTE: All specs will use the bogus calculator (no login information needed)

    let(:address) { FactoryGirl.create(:address) }
    let!(:order) do
      order = FactoryGirl.create(:order_with_line_items, :ship_address => address, :line_items_count => 2)
      order.line_items.first.tap do |line_item|
        line_item.quantity = 2
        line_item.variant.save
        line_item.variant.weight = 1
        line_item.variant.save
        line_item.save
        # product packages?
      end
      order.line_items.last.tap do |line_item|
        line_item.quantity = 2
        line_item.variant.save
        line_item.variant.weight = 2
        line_item.variant.save
        line_item.save
        # product packages?
      end
      order
    end

    let(:carrier) { ActiveMerchant::Shipping::USPS.new(:login => "FAKEFAKEFAKE") }
    let(:calculator) { Spree::Calculator::Shipping::Usps::ExpressMail.new }
    let(:response) { double('response', :rates => rates) }
    let(:package) { order.shipments.first.to_package }

    before(:each) do
      order.create_proposed_shipments
      order.shipments.count.should == 1
      Spree::ActiveShipping::Config.set(:units => "imperial")
      Spree::ActiveShipping::Config.set(:unit_multiplier => 1)
      calculator.stub(:carrier).and_return(carrier)
      Rails.cache.clear
    end

    describe "available" do
      context "when rates are available" do
        let(:rates) do
          [ double('rate', :service_name => 'Service', :service_code => 3, :price => 1) ]
        end

        before do
          carrier.should_receive(:find_rates).and_return(response)
        end

        it "should return true" do
          calculator.available?(package).should be(true)
        end

        it "should use zero as a valid weight for service" do
          calculator.stub(:max_weight_for_country).and_return(0)
          calculator.available?(package).should be(true)
        end
      end

      context "when rates are not available" do
        let(:rates) { [] }

        before do
          carrier.should_receive(:find_rates).and_return(response)
        end

        it "should return false" do
          calculator.available?(package).should be(false)
        end
      end

      context "when there is an error retrieving the rates" do
        before do
          carrier.should_receive(:find_rates).and_raise(ActiveMerchant::ActiveMerchantError)
        end

        it "should return false" do
          calculator.available?(package).should be(false)
        end
      end
    end

    describe "available?" do
      # regression test for #164 and #171
      it "should not return rates if the weight requirements for the destination country are not met" do
        # if max_weight_for_country is nil -> the carrier does not ship to that country
        # if max_weight_for_country is 0 -> the carrier does not have weight restrictions to that country
        calculator.stub(:max_weight_for_country).and_return(nil)
        calculator.should_receive(:is_package_shippable?).and_raise Spree::ShippingError
        calculator.available?(package).should be(false)
      end
    end

    describe "compute" do
      it "should use the carrier supplied in the initializer" do
        stub_request(:get, /http:\/\/production.shippingapis.com\/ShippingAPI.dll.*/).
          to_return(:body => fixture(:normal_rates_request))
        calculator.compute(package).should == 14.1
      end

      xit "should ignore variants that have a nil weight" do
        variant = order.line_items.first.variant
        variant.weight = nil
        variant.save
        calculator.compute(package)
      end

      xit "should create a package with the correct total weight in ounces" do
        # (10 * 2 + 5.25 * 1) * 16 = 404
        Package.should_receive(:new).with(404, [], :units => :imperial)
        calculator.compute(package)
      end

      xit "should check the cache first before finding rates" do
        Rails.cache.fetch(calculator.send(:cache_key, order)) { Hash.new }
        carrier.should_not_receive(:find_rates)
        calculator.compute(package)
      end

      context "with valid response" do
        before do
          carrier.should_receive(:find_rates).and_return(response)
        end

        xit "should return rate based on calculator's service_name" do
          calculator.class.should_receive(:description).and_return("Super Fast")
          rate = calculator.compute(package)
          rate.should == 9.99
        end

        xit "should include handling_fee when configured" do
          calculator.class.should_receive(:description).and_return("Super Fast")
          Spree::ActiveShipping::Config.set(:handling_fee => 100)
          rate = calculator.compute(package)
          rate.should == 10.99
        end

        xit "should return nil if service_name is not found in rate_hash" do
          calculator.class.should_receive(:description).and_return("Extra-Super Fast")
          rate = calculator.compute(package)
          rate.should be_nil
        end
      end
    end

    describe "service_name" do
      it "should return description when not defined" do
        calculator.class.service_name.should == calculator.description
      end
    end
end

end
