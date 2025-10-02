require 'rails_helper'

RSpec.describe Prescription, type: :model do
  describe 'バリデーション' do
    context '正常系' do
      it '有効なデータなら保存できる' do
        prescription = build(:prescription) 
        expect(prescription).to be_valid
      end

      it '患者名が50文字以内なら有効' do
        prescription = build(:prescription, patient_name: "あ" * 50)
        expect(prescription).to be_valid
      end

      it '処方箋アイテムが1つ以上あれば有効' do
        prescription = build(:prescription) 
        expect(prescription.prescription_items).not_to be_empty
        expect(prescription).to be_valid
      end
    end

    context '異常系' do
      it '患者が存在しないと無効' do
        prescription = build(:prescription, patient: nil)
        expect(prescription).not_to be_valid
        expect(prescription.errors[:patient]).to be_present
      end

      it '医師が存在しないと無効' do
        prescription = build(:prescription, doctor: nil)
        expect(prescription).not_to be_valid
        expect(prescription.errors[:doctor]).to be_present
      end

      it '病院名が空だと無効' do
        prescription = build(:prescription, hospital_name: nil)
        expect(prescription).not_to be_valid
        expect(prescription.errors[:hospital_name]).to be_present
      end

      it '患者名が空だと無効' do
        prescription = build(:prescription, patient_name: nil)
        expect(prescription).not_to be_valid
        expect(prescription.errors[:patient_name]).to be_present
      end

      it '患者名が51文字以上だと無効' do
        prescription = build(:prescription, patient_name: "あ" * 51)
        expect(prescription).not_to be_valid
        expect(prescription.errors[:patient_name]).to be_present
      end

      it '有効期限が発行日より前だと無効' do
        prescription = build(:prescription, issued_at: Date.today, expires_at: Date.yesterday)
        expect(prescription).not_to be_valid
        expect(prescription.errors[:expires_at]).to include("は発行日より後の日付にしてください")
      end

      it '処方箋アイテムが空だと無効' do
        prescription = build(:prescription)
        prescription.prescription_items = []
        prescription.valid?
        expect(prescription.errors[:base]).to include("処方箋アイテムを入力してください")
      end
    end
  end

  describe '関連付け' do
    it { is_expected.to belong_to(:patient).class_name('User') }
    it { is_expected.to belong_to(:doctor).class_name('User') }
    it { is_expected.to have_many(:prescription_items).dependent(:destroy) }
    it { is_expected.to have_many(:medications).through(:prescription_items) }
    it { is_expected.to have_many(:status_updates).dependent(:destroy) }
    it { is_expected.to have_many(:qr_scans).dependent(:destroy) }
  end

  describe 'ネスト属性' do
    it 'prescription_items のネストされた属性を受け入れる' do
      doctor = create(:user, :doctor)
      patient = create(:user, :patient)
      prescription = Prescription.new(
        doctor: doctor,
        patient: patient,
        patient_name: "テスト患者",
        hospital_name: "テスト病院",
        issued_at: Date.today,
        expires_at: Date.tomorrow,
        qr_token: SecureRandom.uuid,
        prescription_items_attributes: [
          { medication: create(:medication, :with_image), days: 3, dosage: "1錠", timing: "朝食後" }
        ]
      )
      expect(prescription).to be_valid
      expect(prescription.prescription_items.size).to eq(1)
    end
  end
end



