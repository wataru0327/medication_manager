# app/controllers/patients_controller.rb
class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_patient!, only: [
    :home, :scan_qr, :received, :calendar,
    :calendar_events, :day_schedule_events, :find_by_token
  ]

  require "digest"

  # 💊 受け取った処方箋一覧ページ（保有中以上・新しい順）
  def received
    @received_prescriptions = Prescription
      .joins(:status_updates)
      .where(patient_id: current_user.id, status_updates: { status: [:accepted, :processing, :completed] })
      .includes(:status_updates, prescription_items: [:medication])
      .order(issued_at: :desc)
      .distinct
  end

  # 💊 カレンダーページ表示用（完了済みのみ）
  def calendar
    @received_prescriptions = Prescription
      .joins(:status_updates)
      .where(patient_id: current_user.id, status_updates: { status: :completed })
      .includes(:status_updates, prescription_items: [:medication])
  end

  # 💊 月間カレンダー用（allDayのみ）
  def calendar_events
    completed_prescriptions = Prescription
      .joins(:status_updates)
      .where(patient_id: current_user.id, status_updates: { status: :completed })
      .includes(:status_updates, prescription_items: [:medication])

    selected_meds = params[:meds].present? ? params[:meds].split(",").map(&:strip).reject(&:blank?) : []
    events = []

    completed_prescriptions.each do |prescription|
      completed_at = prescription.status_updates.where(status: :completed).order(created_at: :desc).first&.created_at
      next unless completed_at

      prescription.prescription_items.each do |item|
        next unless item.medication
        next unless selected_meds.include?(item.medication.name)

        color = pastel_color_from_name(item.medication.name)

        item.days.times do |i|
          date = completed_at.to_date + i
          timing_icon = case item.medication.timing
                        when "morning"    then "🌅"
                        when "noon"       then "☀️"
                        when "evening"    then "🌆"
                        when "bedtime"    then "🌙"
                        when "after_meal" then "🍽️"
                        else ""
                        end
          events << {
            id: "allDay-#{item.id}-#{i}",
            title: "#{item.medication.name} #{timing_icon}",
            start: date,
            end:   date + 1.day,
            allDay: true,
            color: color
          }
        end
      end
    end

    render json: events
  end

  # 💊 タイムスケジュール用（薬名のみ表示、毎食後は1日3回）
  def day_schedule_events
    completed_prescriptions = Prescription
      .joins(:status_updates)
      .where(patient_id: current_user.id, status_updates: { status: :completed })
      .includes(:status_updates, prescription_items: [:medication])

    selected_meds = params[:meds].present? ? params[:meds].split(",").map(&:strip).reject(&:blank?) : []
    events = []

    completed_prescriptions.each do |prescription|
      completed_at = prescription.status_updates.where(status: :completed).order(created_at: :desc).first&.created_at
      next unless completed_at

      prescription.prescription_items.each do |item|
        next unless item.medication
        next unless selected_meds.include?(item.medication.name)

        color = pastel_color_from_name(item.medication.name)

        item.days.times do |i|
          date = completed_at.to_date + i

          if item.medication.timing == "after_meal"
            ["08:00", "12:00", "18:00"].each do |time|
              events << {
                id: "time-#{item.id}-#{i}-#{time}",
                title: item.medication.name,
                start: "#{date}T#{time}",
                allDay: false,
                color: color
              }
            end
          else
            start_time = case item.medication.timing
                         when "morning"    then "08:00"
                         when "noon"       then "12:00"
                         when "evening"    then "18:00"
                         when "bedtime"    then "22:00"
                         else "09:00"
                         end

            events << {
              id: "time-#{item.id}-#{i}",
              title: item.medication.name,
              start: "#{date}T#{start_time}",
              allDay: false,
              color: color
            }
          end
        end
      end
    end

    render json: events
  end

  # 💊 QRコードで処方箋を検索（本人のみアクセス可）
  def find_by_token
    prescription = Prescription.find_by(qr_token: params[:token])

    if prescription && prescription.patient_id == current_user.id
      render json: { patient_name: current_user.name, id: prescription.id }
    else
      render json: { error: "これはあなたの処方箋ではありません" }, status: :forbidden
    end
  end

  private

  def ensure_patient!
    redirect_to root_path, alert: "患者のみアクセスできます" unless current_user&.patient?
  end

  def pastel_color_from_name(name)
    hash = Digest::MD5.hexdigest(name).to_i(16)
    hue = hash % 360
    "hsl(#{hue}, 70%, 80%)"
  end
end
























