class StatusUpdatesController < ApplicationController
  before_action :set_status_update, only: %i[ show edit update destroy ]

  # GET /status_updates or /status_updates.json
  def index
    @status_updates = StatusUpdate.all
  end

  # GET /status_updates/1 or /status_updates/1.json
  def show
  end

  # GET /status_updates/new
  def new
    @status_update = StatusUpdate.new
  end

  # GET /status_updates/1/edit
  def edit
  end

  # POST /status_updates or /status_updates.json
  def create
    @status_update = StatusUpdate.new(status_update_params)

    respond_to do |format|
      if @status_update.save
        format.html { redirect_to @status_update, notice: "Status update was successfully created." }
        format.json { render :show, status: :created, location: @status_update }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @status_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /status_updates/1 or /status_updates/1.json
  def update
    respond_to do |format|
      if @status_update.update(status_update_params)
        format.html { redirect_to @status_update, notice: "Status update was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @status_update }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @status_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /status_updates/1 or /status_updates/1.json
  def destroy
    @status_update.destroy!

    respond_to do |format|
      format.html { redirect_to status_updates_path, notice: "Status update was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status_update
      @status_update = StatusUpdate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def status_update_params
      params.require(:status_update).permit(:prescription_id, :pharmacy_id, :status)
    end
end
