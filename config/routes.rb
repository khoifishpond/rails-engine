Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/', to: 'welcome#index'
      
      namespace :merchants do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end

      namespace :items do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end
    end
  end
  
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        get '/items', to: 'merchants/items#index'
      end

      resources :items, only: [:index, :show, :create, :update, :destroy] do
        get '/merchant', to: 'items/merchant#show'
      end
    end
  end

  get '/', to: redirect('/api/v1/')
end
