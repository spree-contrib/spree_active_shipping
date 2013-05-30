Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :active_shipping_settings, :only => ['show', 'update', 'edit']
  end

  get 'admin/products/:product_id/product_packages(.:format)' => 'admin/product_packages#index', :as => 'admin_product_product_packages'
  post 'admin/products/:product_id/product_packages(.:format)' => 'admin/product_packages#create'
  get 'admin/products/:product_id/product_packages/new(.:format)' => 'admin/product_packages#new', :as => 'new_admin_product_product_package'
  get 'admin/products/:product_id/product_packages/:id/edit(.:format)' => 'admin/product_packages#edit', :as => 'edit_admin_product_product_package'
  get 'admin/products/:product_id/product_packages/:id(.:format)' => 'admin/product_packages#show', :as => 'admin_product_product_package'
  put 'admin/products/:product_id/product_packages/:id(.:format)' => 'admin/product_packages#update'
  delete 'admin/products/:product_id/product_packages/:id(.:format)' => 'admin/product_packages#destroy'

end


