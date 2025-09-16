Rails.application.routes.draw do
  devise_for :users
  resources :status_updates
  resources :medications
  resources :prescriptions

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  get "up" => "rails/health#show", as: :rails_health_check
end


