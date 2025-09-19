class Patients::SessionsController < Devise::SessionsController
  def new
    super  # patients/sessions/new.html.erb を使う
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    if resource&.patient?
      set_flash_message!(:notice, :signed_in)
      sign_in(:user, resource)  # ← scope は :user 固定
      redirect_to patient_home_path
    else
      sign_out(:user)
      redirect_to new_patient_session_path, alert: "患者アカウントでログインしてください。"
    end
  end

  protected

  def auth_options
    { scope: :user, recall: "patients/sessions#new" } # ← scope も :user 固定
  end
end




