Rails.application.routes.draw do
  get "lessons/show"
  get "courses/index"
  get "courses/show"
  root "home#index"
  resources :courses, only: [ :index, :show ]
  resources :lessons, only: [ :show ]

  get "up" => "rails/health#show", as: :rails_health_check
end
