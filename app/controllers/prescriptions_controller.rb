class PrescriptionsController < ApplicationController
  before_action :set_prescription, only: %i[ show edit update destroy qrcode ]

  # GET /prescriptions
  def index
    @prescriptions = Prescription.all.includes(:patient, :doctor, :prescription_items)
  end

  # GET /prescriptions/1
  def show
  end

  # GET /prescriptions/new
  def new
    @prescription = Prescription.new
    @prescription.prescription_items.build   # フォームで1行目を表示
  end

  # GET /prescriptions/1/edit
  def edit
    # 編集画面でも prescription_items を最低1つは用意
    @prescription.prescription_items.build if @prescription.prescription_items.empty?
  end

  # POST /prescriptions
  def create
    attrs = prescription_params.merge(
      doctor_id: current_user.id,
      hospital_name: current_user.hospital_name
    )

    # expires_at が空なら issued_at + 4日を自動補完
    if attrs[:issued_at].present? && attrs[:expires_at].blank?
      issued_time = Time.zone.parse(attrs[:issued_at].to_s)
      attrs[:expires_at] = issued_time + 4.days if issued_time
    end

    @prescription = Prescription.new(attrs)

    if @prescription.save
      redirect_to @prescription, notice: "処方箋を登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /prescriptions/1
  def update
    attrs = prescription_params

    # expires_at が空なら issued_at + 4日を自動補完
    if attrs[:issued_at].present? && attrs[:expires_at].blank?
      issued_time = Time.zone.parse(attrs[:issued_at].to_s)
      attrs[:expires_at] = issued_time + 4.days if issued_time
    end

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
    qr = RQRCode::QRCode.new(@prescription.qr_token) # QRトークンをQRコード化
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
    if params[:patient_name].present?
      @prescriptions = Prescription.joins(:patient)
                                   .where("users.name LIKE ?", "%#{params[:patient_name]}%")
                                   .includes(:patient, :doctor)
    else
      @prescriptions = []
    end
  end

  # POST /prescriptions/qrcode_generate
  def qrcode_generate
    @prescription = Prescription.find(params[:prescription_id])
    redirect_to qrcode_prescription_path(@prescription)
  end

  private

  def set_prescription
    @prescription = Prescription.find(params[:id])
  end

  def prescription_params
    params.require(:prescription).permit(
      :patient_id, :hospital_name, :issued_at, :expires_at, :qr_token,
      prescription_items_attributes: [:id, :medication_id, :days, :_destroy]
    )
  end
end





