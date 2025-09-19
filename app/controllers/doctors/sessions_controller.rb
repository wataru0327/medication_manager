class Doctors::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    if resource&.doctor?
      set_flash_message!(:notice, :signed_in)
      sign_in(:user, resource)  # ← scope は :user 固定
      redirect_to doctor_home_path
    else
      sign_out(:user)
      redirect_to new_doctor_session_path, alert: "医師アカウントでログインしてください。"
    end
  end

  protected

  def auth_options
    { scope: :user, recall: "doctors/sessions#new" } # ← scope も :user 固定
  end
end


