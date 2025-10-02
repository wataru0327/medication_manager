class QrScan < ApplicationRecord
  belongs_to :user
  belongs_to :prescription

  validates :token, presence: true
end

