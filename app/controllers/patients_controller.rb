class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_patient!, only: [:home, :scan_qr]

  # 💊 患者用トップページ
  def home
    # 患者専用のページ
  end

  # 💊 QRコード読み取りページ（患者専用）
  def scan_qr
    if params[:token].present?
      # ✅ 自分の処方箋だけを検索
      @prescription = Prescription.find_by(
        qr_token: params[:token],
        patient_id: current_user.id
      )

      if @prescription
        redirect_to prescription_path(@prescription), notice: "処方箋を確認しました"
      else
        flash.now[:alert] = "これはあなたの処方箋ではありません"
      end
    end
  end

  # 💊 ユーザー番号から患者を検索（Ajax 用）
  def find_by_number
    user = User.find_by(patient_number: params[:number])

    if user&.patient?
      render json: { id: user.id, name: user.name }
    else
      render json: { error: "患者が見つかりません" }, status: :not_found
    end
  end

  # 💊 QRコードトークンから処方箋を検索（患者専用API）
  def find_by_token
    prescription = Prescription.find_by(qr_token: params[:token], patient_id: current_user.id)

    if prescription
      render json: { patient_name: current_user.name }
    else
      render json: { error: "これはあなたの処方箋ではありません" }, status: :forbidden
    end
  end

  private

  def ensure_patient!
    redirect_to root_path, alert: "患者のみアクセスできます" unless current_user&.patient?
  end
end



