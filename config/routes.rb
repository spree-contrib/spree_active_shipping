Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :active_shipping_settings, :only => ['show', 'update', 'edit']
  end
end
