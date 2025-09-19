class MedicationsController < ApplicationController
  before_action :set_medication, only: %i[ show edit update destroy ]

  def index
    @medications = Medication.all

    # 🔍 検索条件
    if params[:name].present?
      @medications = @medications.where("name LIKE ?", "%#{params[:name]}%")
    end

    if params[:purpose].present?
      @medications = @medications.where(purpose: params[:purpose])
    end
  end

  def show
  end

  def new
    @medication = Medication.new
  end

  def edit
  end

  def create
    @medication = Medication.new(medication_params)

    respond_to do |format|
      if @medication.save
        format.html { redirect_to @medication, notice: "薬が登録されました。" }
        format.json { render :show, status: :created, location: @medication }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @medication.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @medication.update(medication_params)
        format.html { redirect_to @medication, notice: "薬情報を更新しました。", status: :see_other }
        format.json { render :show, status: :ok, location: @medication }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medication.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @medication.destroy!

    respond_to do |format|
      format.html { redirect_to medications_path, notice: "薬を削除しました。", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

    def set_medication
      @medication = Medication.find(params[:id])
    end

    def medication_params
      params.require(:medication).permit(:name, :dosage, :timing, :purpose, :note, :image)
    end
end


