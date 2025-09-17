class ApplicationController < ActionController::Base
  # Devise コントローラの場合のみ追加パラメータを許可
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ログイン後のリダイレクト先を指定
  def after_sign_in_path_for(resource)
    prescriptions_path # ログイン後は処方箋一覧へ
  end

  protected

  # Deviseで追加したカラムを許可
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role])
  end
end
