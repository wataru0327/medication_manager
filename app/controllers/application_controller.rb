class ApplicationController < ActionController::Base
  # Devise コントローラの場合のみ追加パラメータを許可
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ログイン後のリダイレクト先を指定
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

  protected

  # Deviseで追加したカラムを許可
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :hospital_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role, :hospital_name])
  end
end


