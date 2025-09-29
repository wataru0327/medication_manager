Rails.application.routes.draw do
  # ✅ 飲み忘れ防止チェック（服薬記録）
  resources :medication_intakes, only: [:create, :destroy]

  # 共通 User モデルを使う（sessions / registrations は自作するので skip）
  devise_for :users, skip: [:sessions, :registrations]

  devise_scope :user do
    # 患者
    get    "patients/sign_in",   to: "patients/sessions#new",         as: :new_patient_session
    post   "patients/sign_in",   to: "patients/sessions#create",      as: :patient_session
    get    "patients/sign_up",   to: "patients/registrations#new",    as: :new_patient_registration
    post   "patients",           to: "patients/registrations#create", as: :patient_registration
    delete "patients/sign_out",  to: "patients/sessions#destroy",     as: :destroy_patient_session

    # 医師
    get    "doctors/sign_in",    to: "doctors/sessions#new",          as: :new_doctor_session
    post   "doctors/sign_in",    to: "doctors/sessions#create",       as: :doctor_session
    get    "doctors/sign_up",    to: "doctors/registrations#new",     as: :new_doctor_registration
    post   "doctors",            to: "doctors/registrations#create",  as: :doctor_registration
    delete "doctors/sign_out",   to: "doctors/sessions#destroy",      as: :destroy_doctor_session

    # 薬局
    get    "pharmacies/sign_in",   to: "pharmacies/sessions#new",         as: :new_pharmacy_session
    post   "pharmacies/sign_in",   to: "pharmacies/sessions#create",      as: :pharmacy_session
    get    "pharmacies/sign_up",   to: "pharmacies/registrations#new",    as: :new_pharmacy_registration
    post   "pharmacies",           to: "pharmacies/registrations#create", as: :pharmacy_registration
    delete "pharmacies/sign_out",  to: "pharmacies/sessions#destroy",     as: :destroy_pharmacy_session
  end

  # 各ロール専用トップページ
  get "patients/home",   to: "patients#home",   as: :patient_home
  get "doctors/home",    to: "doctors#home",    as: :doctor_home
  get "pharmacies/home", to: "pharmacies#home", as: :pharmacy_home

  # 患者機能
  resources :patients, only: [] do
    collection do
      get :scan_qr
      get :find_by_number
      get :find_by_token
      get :received
      get :calendar                                     # 📅 カレンダー画面
      get :calendar_events, defaults: { format: :json } # 📅 月間カレンダー用JSON
      get :day_schedule_events, defaults: { format: :json } # 🕒 タイムスケジュール用JSON
    end
  end

  # ✅ 処方箋
  resources :prescriptions do
    member do
      get  :qrcode
      post :receive          # 患者が受け取り（POST）
      post :update_status    # 薬局が更新（POST）
    end
    collection do
      get  :qrcode_search
      post :qrcode_generate
      get  :find_by_token
    end
  end

  resources :medications
  resources :status_updates

  # 薬局機能
  resources :pharmacies, only: [] do
    collection do
      get :scan_qr
      get :accepted_prescriptions
      get :completed_prescriptions
    end
  end

  unauthenticated do
    root to: "home#index", as: :unauthenticated_root
  end

  get "up" => "rails/health#show", as: :rails_health_check
end


























