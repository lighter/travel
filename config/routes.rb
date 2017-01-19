Rails.application.routes.draw do
    resources :users, exception: [:new] do
        collection do
            get 'sign_up', action: :new
        end
    end
    root 'home_page#index'
end
