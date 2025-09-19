class Pharmacies::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    if resource&.pharmacy?
      set_flash_message!(:notice, :signed_in)
      sign_in(:user, resource)  # ← scope は常に :user
      redirect_to pharmacy_home_path
    else
      sign_out(:user)
      redirect_to new_pharmacy_session_path, alert: "薬局アカウントでログインしてください。"
    end
  end

  protected

  def auth_options
    { scope: :user, recall: "pharmacies/sessions#new" } # ← scope も :user 固定
  end
end


