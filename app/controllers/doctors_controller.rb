class DoctorsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_doctor

  def home
  end

  private

  def ensure_doctor
    redirect_to root_path, alert: "アクセス権限がありません" unless current_user.doctor?
  end
end
