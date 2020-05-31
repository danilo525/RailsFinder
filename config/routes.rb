Rails.application.routes.draw do

  get 'main/search'
  root 'main#index'

  resources :main
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
