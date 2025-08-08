Rails.application.routes.draw do
  resources :customers
  resources :plans
  resources :additional_services
  resources :packages
  resources :subscriptions
end
