Spree::Core::Engine.add_routes do
  namespace :admin do
    resource :active_shipping_settings, :only => ['show', 'update', 'edit']

    resources :products, :only => [] do
      resources :product_packages
    end
  end
end
