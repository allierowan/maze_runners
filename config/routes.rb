Rails.application.routes.draw do
  resources :grids, only: [:show, :create, :update]

  root to: "grids#create"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
