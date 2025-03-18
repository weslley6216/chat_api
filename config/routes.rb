Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  post 'login', to: 'authentication#login'

  resources :users, only: %i[ index create ]
  resources :conversations do
    resources :messages, only: %i[index create update destroy]
  end
end
