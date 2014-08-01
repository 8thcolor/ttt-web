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
end
