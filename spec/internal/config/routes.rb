Rails.application.routes.draw do
  resources :products, :defaults => { :format => :json }
  resources :categories, :defaults => { :format => :json }
end
