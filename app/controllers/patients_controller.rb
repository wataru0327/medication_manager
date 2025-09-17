class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_patient!

  def home
    # 患者用のページ
  end

  private

  def ensure_patient!
    redirect_to root_path, alert: "患者のみアクセスできます" unless current_user.patient?
  end
end

