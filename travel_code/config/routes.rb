Rails.application.routes.draw do
  root 'home_page#index'
  post 'home/attractions' => 'home_page#ajaxGetAttractions'

  get 'password_reset/new'
  get 'password_reset/edit'

  get 'log_in' => 'sessions#new'
  post 'log_in' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users, except: [:new] do
    member do
      get :favorite, :attraction
    end
  end
  
  get 'sign_up' => 'users#new'

  # omniauth facebook
  match 'auth/:provider/callback' => 'users#create', via: [:get, :post]
  match 'auth/failure' => redirect('/'), via: [:get, :post]

  resources :account_activations, only: [:edit]
  resources :password_reset, only: [:new, :create, :edit, :update]
  
  resources :attractions do
    collection do
      get 'search_user'
      get 'search'
    end

    member do
      post 'favorite'
      post 'unfavorite'
      get 'user' => 'attractions#user_attraction'
    end
  end

  resources :categories
end
