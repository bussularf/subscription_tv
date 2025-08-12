Rails.application.routes.draw do
  root "home#index"

  resources :customers
  resources :plans
  resources :additional_services
  resources :packages
  resources :subscriptions
end
