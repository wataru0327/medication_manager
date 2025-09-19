# app/controllers/pharmacies/registrations_controller.rb
class Pharmacies::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    # role を pharmacy に固定
    resource.role = "pharmacy"

    if resource.save
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        redirect_to pharmacy_home_path
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
