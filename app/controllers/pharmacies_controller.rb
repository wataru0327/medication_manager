class PharmaciesController < ApplicationController
  include ActionView::RecordIdentifier   # dom_id を使うために必要

  before_action :authenticate_user!
  before_action :ensure_pharmacy

  # 💊 薬局トップページ
  def home; end

  # 💊 QRコード読み取り専用ページ
  def scan_qr
    if params[:token].present?
      @prescription = Prescription.find_by(qr_token: params[:token])

      if @prescription
        # ✅ 履歴を保存（最新5件管理）
        current_user.qr_scans.create!(
          prescription: @prescription,
          token: params[:token]
        )
        current_user.qr_scans.order(created_at: :desc).offset(5).destroy_all

        # ✅ 最新ステータスを確認
        latest_status = @prescription.status_updates.order(created_at: :desc).first

        # ✅ completed 以外のときのみ accepted に更新
        unless latest_status&.status == "completed"
          StatusUpdate.create!(
            prescription: @prescription,
            pharmacy: current_user,
            status: :accepted
          )
        end

        redirect_to prescription_path(@prescription), notice: "処方箋を受付しました"
        return
      else
        flash.now[:alert] = "該当する処方箋が見つかりません"
      end
    end

    # ✅ 直近の履歴5件を取得
    @scan_history = current_user.qr_scans
                                .includes(prescription: [:patient])
                                .order(created_at: :desc)
                                .limit(5)
  end

  # 💊 受付済み処方箋一覧
  def accepted_prescriptions
    latest_statuses = StatusUpdate.select("DISTINCT ON (prescription_id) *")
                                  .where(pharmacy_id: current_user.id)
                                  .order("prescription_id, created_at DESC")

    @accepted = StatusUpdate.joins("INNER JOIN (#{latest_statuses.to_sql}) AS latest ON latest.id = status_updates.id")
                            .where("latest.status != ?", StatusUpdate.statuses[:completed])
                            .where("latest.pharmacy_id = ?", current_user.id)
                            .includes(prescription: :patient)
                            .order("latest.created_at DESC")
  end

  # 💊 完了済み処方箋一覧
  def completed_prescriptions
    latest_statuses = StatusUpdate.select("DISTINCT ON (prescription_id) *")
                                  .where(pharmacy_id: current_user.id)
                                  .order("prescription_id, created_at DESC")

    @status_updates = StatusUpdate
                        .joins("INNER JOIN (#{latest_statuses.to_sql}) AS latest ON latest.id = status_updates.id")
                        .joins(prescription: :patient)   # ✅ JOIN users テーブル（エイリアス patient）
                        .where("latest.status = ?", StatusUpdate.statuses[:completed])
                        .where("latest.pharmacy_id = ?", current_user.id)
                        .includes(prescription: :patient)
                        .order("latest.created_at DESC")

    if params[:q].present?
      keyword = "%#{params[:q]}%"
      @status_updates = @status_updates.where(
        "CAST(users.patient_number AS TEXT) LIKE :kw OR users.name LIKE :kw",
        kw: keyword
      )
    end

    # ✅ ビューを明示的に指定（既存 index を利用）
    render "status_updates/index"
  end

  # 💊 ステータス更新（Turbo対応）
  def update_status
    @prescription = Prescription.find(params[:id])
    @record = StatusUpdate.create!(
      prescription: @prescription,
      pharmacy: current_user,
      status: params[:status]
    )

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          dom_id(@prescription, :status_button),
          partial: "prescriptions/status_button",
          locals: { prescription: @prescription }
        )
      end
      format.html do
        if params[:status] == "completed"
          redirect_to completed_prescriptions_pharmacies_path, notice: "お薬の受け渡しを完了しました"
        else
          redirect_to prescription_path(@prescription), notice: "ステータスを更新しました"
        end
      end
    end
  end

  private

  def ensure_pharmacy
    redirect_to root_path, alert: "アクセス権限がありません" unless current_user&.pharmacy?
  end
end




















