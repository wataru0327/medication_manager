class StatusUpdate < ApplicationRecord
  belongs_to :prescription
  belongs_to :pharmacy, class_name: "User", optional: true

  enum status: {
    pending: 0,      # 患者保有
    accepted: 1,     # 受付済み
    processing: 2,   # 調剤中
    completed: 3     # 完了
  }

  validates :prescription_id, :status, presence: true

  # ✅ 日本語ラベルを返すメソッド
  def status_label
    case status
    when "pending"    then "患者が保有中"
    when "accepted"   then "受付済み"
    when "processing" then "調剤中"
    when "completed"  then "完了"
    else status
    end
  end
end


