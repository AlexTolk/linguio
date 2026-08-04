Rails.application.routes.draw do
  devise_for :users

  root "home#index"
  resources :courses, only: [:index, :show]
  
  resources :lessons, only: [:show] do
    member do
      get :complete
    end

    resources :lesson_sections, only: [] do
      resources :exercises, only: [:show] do
        post :submit, on: :member
        get :result, on: :member
      end
    end
  end

  namespace :admin do
    root to: "dashboard#index"

    resources :courses do
      resources :course_sections, except: [:index, :show]
    end

    resources :course_sections, only: [] do
      resources :lessons, except: [:index]
    end

    resources :lessons, only: [] do
      resources :lesson_sections, except: [:index]
    end

    resources :lesson_sections, only: [] do
      resources :exercises, except: [:index]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
