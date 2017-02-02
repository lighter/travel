Rails.application.routes.draw do
  get 'password_reset/new'

  get 'password_reset/edit'

    root 'home_page#index'

    get 'log_in' => 'sessions#new'
    post 'log_in' => 'sessions#create'
    delete 'logout' => 'sessions#destroy'

    resources :users, except: [:new]
    get 'sign_up' => 'users#new'

    resources :account_activations, only: [:edit]
    resources :password_reset, only: [:new, :create, :edit, :update]
end
