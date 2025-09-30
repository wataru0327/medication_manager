require 'rails_helper'

RSpec.describe Prescription, type: :model do
  subject { create(:prescription) }

  describe 'バリデーション' do
    it { should validate_presence_of(:doctor_id) }
    it { should validate_presence_of(:issued_at) }
    it { should validate_presence_of(:expires_at) }
    it { should validate_presence_of(:qr_token) }

    # 👇 case_sensitive に変更
    it { should validate_uniqueness_of(:qr_token) }

    it { should validate_presence_of(:patient_name) }
    it { should validate_length_of(:patient_name).is_at_most(50) }

    it '有効期限が発行日より前だと無効' do
      prescription = build(:prescription,
        issued_at: Date.today,
        expires_at: Date.yesterday
      )
      expect(prescription).not_to be_valid
      expect(prescription.errors[:expires_at]).to include("は発行日より後の日付にしてください")
    end
  end

  describe '関連付け' do
    it { should belong_to(:patient).class_name('User').optional }
    it { should belong_to(:doctor).class_name('User') }
    it { should have_many(:prescription_items).dependent(:destroy) }
    it { should have_many(:medications).through(:prescription_items) }
    it { should have_many(:status_updates).dependent(:destroy) }
  end

  describe 'ネスト属性' do
    it 'prescription_items のネストされた属性を受け入れる' do
      doctor = create(:user, :doctor)
      prescription = Prescription.new(
        doctor: doctor,
        patient_name: "テスト患者",
        issued_at: Date.today,
        expires_at: Date.tomorrow,
        qr_token: SecureRandom.uuid,
        prescription_items_attributes: [
          { medication: create(:medication), days: 3 }
        ]
      )
      expect(prescription).to be_valid
      expect(prescription.prescription_items.size).to eq(1)
    end
  end
end


