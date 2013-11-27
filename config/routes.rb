Mori::Application.routes.draw do
  resources :sources

  devise_for :users, controllers:  { omniauth_callbacks: "users/omniauth_callbacks" ,registrations: "users/registrations"}
  resources :chapters,only: [:show]
  resources :categories,only: [:show]
  resources :books,only: [:show,:index]
  root "main#index"
end