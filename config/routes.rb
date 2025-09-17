Rails.application.routes.draw do
  devise_for :users

  # 各リソース
  resources :status_updates
  resources :medications
  resources :prescriptions

  # 各ロール専用トップページ
  get "patients/home", to: "patients#home", as: :patient_home
  get "doctors/home",  to: "doctors#home",  as: :doctor_home
  get "pharmacies/home", to: "pharmacies#home", as: :pharmacy_home

  # ログインしていない場合はログイン画面へ
  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end

  # ヘルスチェック用
  get "up" => "rails/health#show", as: :rails_health_check
end


