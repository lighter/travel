Rails.application.routes.draw do
    get 'log_in' => 'sessions#new'
    post 'log_in' => 'sessions#create'
    delete 'logout' => 'sessions#destroy'

    # resources :users, except: [:new] do
    #     collection do
    #         get 'sign_up', action: :new
    #     end
    # end

    resources :users, except: [:new]
    get 'sign_up' => 'users#new'

    root 'home_page#index'
end
