# app/controllers/patients/registrations_controller.rb
class Patients::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    # 強制的に role を patient に固定
    resource.role = "patient"

    if resource.save
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        redirect_to patient_home_path
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        redirect_to unauthenticated_root_path
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
end
