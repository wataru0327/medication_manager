Rails.application.routes.draw do
  get 'home/index'
  devise_for :users

  # 各リソース
  resources :status_updates
  resources :medications
  resources :prescriptions

  # 各ロール専用トップページ
  get "patients/home",   to: "patients#home",   as: :patient_home
  get "doctors/home",    to: "doctors#home",    as: :doctor_home
  get "pharmacies/home", to: "pharmacies#home", as: :pharmacy_home

  # アプリ全体のトップページ（ロール選択画面）
  root "home#index"

  # ヘルスチェック用
  get "up" => "rails/health#show", as: :rails_health_check
end



