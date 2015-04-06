require 'spec_helper'

describe Spree::Admin::ProductPackagesController do
  stub_authorization!

  context '#index' do
    let(:product) { create(:product) }

    it 'should find ProductPackages for the product and render the view' do
      spree_get :index, product_id: product.slug
      expect(assigns(:product)).to eq(product)
      expect(response).to be_ok
      expect(response).to render_template('index')
    end
  end

  context '#update' do
    let!(:product) { create(:product) }
    let!(:product_package) { create(:product_package, product: product) }

    it 'should allow us to update the ProductPackage attributes' do
      new_length = SecureRandom.random_number(19) + 1
      new_width = SecureRandom.random_number(19) + 1
      new_height = SecureRandom.random_number(19) + 1
      new_weight = SecureRandom.random_number(19) + 1
      spree_post :update, product_id: product.slug, id: product_package.id,
                          product_package: { length: new_length, width: new_width, 
                                             height: new_height, weight: new_weight }
      product_package.reload
      expect(product_package.length).to eq(new_length)
      expect(product_package.width).to eq(new_width)
      expect(product_package.height).to eq(new_height)
      expect(product_package.weight).to eq(new_weight)
    end
  end
end