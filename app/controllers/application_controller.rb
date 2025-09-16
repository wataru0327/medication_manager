class ApplicationController < ActionController::Base
  # Deviseで追加カラムを許可
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    prescriptions_path  # ログイン後に処方箋一覧へ
  end

  protected

  # name と role を許可する
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role])
  end
end
