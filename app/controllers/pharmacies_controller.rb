class PharmaciesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_pharmacy

  def home
  end

  private

  def ensure_pharmacy
    redirect_to root_path, alert: "アクセス権限がありません" unless current_user&.pharmacy?
  end
end
