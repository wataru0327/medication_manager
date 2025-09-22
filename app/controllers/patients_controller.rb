class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_patient!, only: [:home]

  def home
    # 患者用のページ
  end

  # ユーザー番号から患者を検索（Ajax 用）
  def find_by_number
    user = User.find_by(patient_number: params[:number])
    if user
      # name カラムがある場合
      render json: { id: user.id, name: user.name }

      # もし last_name / first_name に分かれている場合はこちら
      # render json: { id: user.id, name: "#{user.last_name} #{user.first_name}" }
    else
      render json: { error: "患者が見つかりません" }, status: :not_found
    end
  end

  private

  def ensure_patient!
    redirect_to root_path, alert: "患者のみアクセスできます" unless current_user.patient?
  end
end



