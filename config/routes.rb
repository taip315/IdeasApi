Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
resources :categories, only: :index
resources :ideas, only: :create
end
