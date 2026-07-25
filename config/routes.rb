Rails.application.routes.draw do
  get "exercises/show"
  get "lessons/show"
  get "courses/index"
  get "courses/show"
  root "home#index"
  resources :courses, only: [ :index, :show ]
  resources :lessons, only: [:show] do
  resources :lesson_sections, only: [] do
      resources :exercises, only: [:show]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
