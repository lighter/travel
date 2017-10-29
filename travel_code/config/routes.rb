Rails.application.routes.draw do
  root 'home_page#index'
  post 'home/attractions' => 'home_page#ajaxGetAttractions'

  get 'password_reset/new'
  get 'password_reset/edit'

  get 'log_in' => 'sessions#new'
  post 'log_in' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users, except: [:new]
  get 'sign_up' => 'users#new'

  # omniauth facebook
  match 'auth/:provider/callback' => 'users#create', via: [:get, :post]
  match 'auth/failure' => redirect('/'), via: [:get, :post]

  resources :account_activations, only: [:edit]
  resources :password_reset, only: [:new, :create, :edit, :update]

  get 'attractions' => 'attractions#index'
  get 'attractions/new' => 'attractions#new', as: :attraction_new
  get 'attractions/:id/edit' => 'attractions#edit', as: :attraction
  put 'attractions/:id' => 'attractions#update', as: :attraction_edit
  post 'attractions' => 'attractions#create'
  delete 'attractions/:id' => 'attractions#destroy', as: :attraction_destroy
  get 'attractions/search' => 'attractions#search'
  post 'attraction/favorite/:id' => 'attractions#favorite'
  post 'attraction/unfavorite/:id' => 'attractions#unfavorite'

  get 'categories' => 'categories#index'
  get 'categories/new' => 'categories#new', as: :category_new
  get 'categories/:id/edit' => 'categories#edit', as: :category
  put 'categories/:id' => 'categories#update', as: :category_edit
  post 'categories' => 'categories#create'
  delete 'categories/:id' => 'categories#destroy', as: :category_destroy
  
end
