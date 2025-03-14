Rails.application.routes.draw do
  resources :users, only: %i[ create ]
  resources :conversations do
    resources :messages, only: %i[index create update destroy]
  end
end
