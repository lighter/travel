Rails.application.routes.draw do
    get 'log_in' => 'sessions#new'
    post 'log_in' => 'sessions#create'
    delete 'logout' => 'sessions#destroy'

    resources :users, exception: [:new] do
        collection do
            get 'sign_up', action: :new
        end
    end
    root 'home_page#index'
end
