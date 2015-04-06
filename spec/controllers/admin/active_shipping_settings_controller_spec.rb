require 'spec_helper'

describe Spree::Admin::ActiveShippingSettingsController do
  stub_authorization!

  context '#edit' do
    it 'should assign a Spree::ActiveShippingConfiguration and render the view' do
      spree_get :edit
      expect(assigns(:config)).to be_an_instance_of(Spree::ActiveShippingConfiguration)
      expect(response).to render_template('edit')
    end
  end

  context '#update' do
    config = Spree::ActiveShippingConfiguration.new
    config.defined_preferences.each do |name, orig_val|
      case config.preference_type(name)
      when :integer
        it "should allow us to set the value of #{name}" do
          new_val = SecureRandom.random_number(100)
          spree_post :update, name => new_val
          expect(Spree::ActiveShippingConfiguration.new.send("preferred_#{name}")).to eq(new_val)
          expect(response).to redirect_to(spree.edit_admin_active_shipping_settings_path)
        end
      when :string
        it "should allow us to set the value of #{name}" do
          new_val = SecureRandom.hex(5)
          spree_post :update, name => new_val
          expect(Spree::ActiveShippingConfiguration.new.send("preferred_#{name}")).to eq(new_val)
          expect(response).to redirect_to(spree.edit_admin_active_shipping_settings_path)
        end
      when :boolean
        it "should allow us to switch the value of #{name}" do
          spree_post :update, name => !orig_val
          expect(Spree::ActiveShippingConfiguration.new.send("preferred_#{name}")).to eq(!orig_val)
          expect(response).to redirect_to(spree.edit_admin_active_shipping_settings_path)
        end
      end
    end

    it "doesn't product an error when passed an invalid parameter name" do
      spree_post :update, 'not_real_parameter_name' => 'not_real'
      expect(response).to redirect_to(spree.edit_admin_active_shipping_settings_path)
    end
  end
end