TttWeb::Application.routes.draw do
  resources :saved_games do
    member do
      post 'play'
    end
  end

  resources :api_games do
    member do
      post 'play'
    end
  end

  resources :mail_games do
    collection do
      post 'play'
    end
  end

  root 'home#index'
end
