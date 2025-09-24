class PrescriptionsController < ApplicationController
  before_action :set_prescription, only: %i[ show edit update destroy qrcode ]

  # GET /prescriptions
  def index
    # ✅ 自分（ログイン中の医師）が作った処方箋だけ表示
    if current_user&.doctor?
      @prescriptions = Prescription.where(doctor_id: current_user.id)
                                   .includes(:patient, :doctor, :prescription_items)
                                   .order(created_at: :desc)
    else
      @prescriptions = Prescription.none
      redirect_to root_path, alert: "アクセス権限がありません"
    end
  end

  # GET /prescriptions/1
  def show; end

  # GET /prescriptions/new
  def new
    @prescription = Prescription.new
    @prescription.prescription_items.build   # フォームで1行目を表示
  end

  # GET /prescriptions/1/edit
  def edit
    @prescription.prescription_items.build if @prescription.prescription_items.empty?
  end

  # POST /prescriptions
  def create
    attrs = prescription_params.merge(
      doctor_id: current_user.id,
      hospital_name: current_user.hospital_name
    )
    attrs = set_defaults(attrs)

    @prescription = Prescription.new(attrs)

    if @prescription.save
      redirect_to @prescription, notice: "処方箋を登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /prescriptions/1
  def update
    attrs = set_defaults(prescription_params)

    if @prescription.update(attrs)
      redirect_to @prescription, notice: "処方箋を更新しました。", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /prescriptions/1
  def destroy
    @prescription.destroy!
    redirect_to prescriptions_path, notice: "処方箋を削除しました。", status: :see_other
  end

  # GET /prescriptions/1/qrcode
  def qrcode
    qr = RQRCode::QRCode.new(@prescription.qr_token)
    @svg = qr.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true
    )
  end

  # GET /prescriptions/qrcode_search
  def qrcode_search
    if params[:q].present?
      keyword = params[:q].to_s.strip

      if keyword.match?(/\A\d+\z/) # 数字のみなら完全一致
        @prescriptions = Prescription.includes(:patient, :doctor).where(patient_number: keyword)
      else # 名前検索は部分一致
        @prescriptions = Prescription.includes(:patient, :doctor).where("patient_name LIKE ?", "%#{keyword}%")
      end
    else
      @prescriptions = []
    end
  end

  # POST /prescriptions/qrcode_generate
  def qrcode_generate
    @prescription = Prescription.find(params[:prescription_id])
    redirect_to qrcode_prescription_path(@prescription)
  end

  # ✅ QRコード用：tokenから患者情報を返すAPI
  def find_by_token
    prescription = Prescription.includes(:patient).find_by(qr_token: params[:token])
    if prescription&.patient
      render json: { patient_name: prescription.patient.name }
    else
      render json: { patient_name: nil }
    end
  end

  private

  def set_prescription
    @prescription = Prescription.find(params[:id])
  end

  def prescription_params
    params.require(:prescription).permit(
      :patient_id, :patient_number, :patient_name,
      :hospital_name, :issued_at, :expires_at, :qr_token,
      prescription_items_attributes: [:id, :medication_id, :days, :_destroy]
    )
  end

  # ✅ 有効期限補完と患者検索を共通処理にまとめた
  def set_defaults(attrs)
    # expires_at が空なら issued_at + 4日を自動補完
    if attrs[:issued_at].present? && attrs[:expires_at].blank?
      issued_time = Time.zone.parse(attrs[:issued_at].to_s)
      attrs[:expires_at] = issued_time + 4.days if issued_time
    end

    # 患者番号から patient を特定
    if attrs[:patient_number].present?
      patient = User.find_by(patient_number: attrs[:patient_number], role: :patient)
      if patient
        attrs[:patient_id]     = patient.id
        attrs[:patient_name]   = patient.name
        attrs[:patient_number] = patient.patient_number
      else
        flash.now[:alert] = "患者番号が見つかりません"
      end
    end

    attrs
  end
end








