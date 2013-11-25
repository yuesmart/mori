Mori::Application.routes.draw do
  devise_for :users, controllers:  { omniauth_callbacks: "users/omniauth_callbacks" ,registrations: "users/registrations"}
  resources :chapters
  resources :categories
  resources :books
  root "main#index"
end
