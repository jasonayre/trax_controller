Rails.application.routes.draw do
  resources :products, :defaults => { :format => :json }
  resources :widgets, :defaults => { :format => :json }
  resources :categories, :defaults => { :format => :json } do
    collection do
      post 'create_with_modified_response_codes'
      post 'create_with_modified_resource'
    end

    member do
      delete 'destroy_with_modified_response_codes'
      get 'show_without_products'
      get 'show_by_calling_original_action'
      get 'widget'
      get 'widget_with_renamed_root'
      get 'product_with_category'
    end
  end
end
