class MedicationIntakesController < ApplicationController
  before_action :authenticate_user!

  # ✅ チェックをつけたとき
  def create
    intake = current_user.medication_intakes.new(medication_intake_params)

    if intake.save
      render json: { success: true }
    else
      render json: { success: false, errors: intake.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ✅ チェックを外したとき
  def destroy
    intake = current_user.medication_intakes.find_by(
      prescription_item_id: params[:prescription_item_id],
      taken_at: Date.today.all_day
    )

    if intake&.destroy
      render json: { success: true }
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  private

  # ✅ Strong Parameters
  def medication_intake_params
    params.require(:medication_intake).permit(:prescription_item_id, :taken_at)
  end
end

