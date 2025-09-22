Rails.application.routes.draw do
  # 共通 User モデルを使う（sessions / registrations は自作するので skip）
  devise_for :users, skip: [:sessions, :registrations]

  devise_scope :user do
    # 患者
    get    "patients/sign_in",   to: "patients/sessions#new",        as: :new_patient_session
    post   "patients/sign_in",   to: "patients/sessions#create",     as: :patient_session
    get    "patients/sign_up",   to: "patients/registrations#new",   as: :new_patient_registration
    post   "patients",           to: "patients/registrations#create",as: :patient_registration
    delete "patients/sign_out",  to: "patients/sessions#destroy",    as: :destroy_patient_session

    # 医師
    get    "doctors/sign_in",    to: "doctors/sessions#new",         as: :new_doctor_session
    post   "doctors/sign_in",    to: "doctors/sessions#create",      as: :doctor_session
    get    "doctors/sign_up",    to: "doctors/registrations#new",    as: :new_doctor_registration
    post   "doctors",            to: "doctors/registrations#create", as: :doctor_registration
    delete "doctors/sign_out",   to: "doctors/sessions#destroy",     as: :destroy_doctor_session

    # 薬局
    get    "pharmacies/sign_in",   to: "pharmacies/sessions#new",         as: :new_pharmacy_session
    post   "pharmacies/sign_in",   to: "pharmacies/sessions#create",      as: :pharmacy_session
    get    "pharmacies/sign_up",   to: "pharmacies/registrations#new",    as: :new_pharmacy_registration
    post   "pharmacies",           to: "pharmacies/registrations#create", as: :pharmacy_registration
    delete "pharmacies/sign_out",  to: "pharmacies/sessions#destroy",     as: :destroy_pharmacy_session
  end

  # 各リソース
  resources :prescriptions do
    member do
      get :qrcode   # 個別処方箋のQRコード表示
    end
    collection do
      get  :qrcode_search   # QRコード作成ページ（患者名で検索）
      post :qrcode_generate # 検索結果からQRコード生成
    end
  end

  resources :medications
  resources :status_updates

  # 未ログイン時トップ
  unauthenticated do
    root to: "home#index", as: :unauthenticated_root
  end

  # 各ロール専用トップページ
  get "patients/home",   to: "patients#home",   as: :patient_home
  get "doctors/home",    to: "doctors#home",    as: :doctor_home
  get "pharmacies/home", to: "pharmacies#home", as: :pharmacy_home

  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check
end













