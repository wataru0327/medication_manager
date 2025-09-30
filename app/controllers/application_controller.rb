class ApplicationController < ActionController::Base
  # Devise コントローラの場合のみ追加パラメータを許可
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ✅ 本番環境のみベーシック認証
  before_action :basic_auth, if: :production?

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    case resource.role
    when "patient"
      patient_home_path
    when "doctor"
      doctor_home_path
    when "pharmacy"
      pharmacy_home_path
    else
      root_path
    end
  end

  # 新規登録後も同じ動きにする
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # ✅ ログアウト後のリダイレクト先を追加
  def after_sign_out_path_for(resource_or_scope)
    unauthenticated_root_path # => home#index に戻す
  end

  protected

  # Deviseで追加したカラムを許可
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :hospital_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :hospital_name])
  end

  private

  # ✅ ベーシック認証
  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  # ✅ 本番環境のみ実行
  def production?
    Rails.env.production?
  end
end





