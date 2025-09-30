require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it '名前・メール・パスワードがあれば有効' do
      user = build(:user)
      expect(user).to be_valid
    end

    it '名前がなければ無効' do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end

    it 'メールがなければ無効' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'メールが重複すると無効' do
      create(:user, email: "duplicate@example.com")
      user = build(:user, email: "duplicate@example.com")
      expect(user).not_to be_valid
    end

    # ✅ subject に有効なユーザーを渡す
    subject { build(:user, :patient) }
    it { should validate_uniqueness_of(:patient_number).allow_nil }
  end

  describe '関連付け' do
    it { is_expected.to have_many(:doctor_prescriptions).class_name("Prescription").with_foreign_key("doctor_id") }
    it { is_expected.to have_many(:patient_prescriptions).class_name("Prescription").with_foreign_key("patient_id") }
    it { is_expected.to have_many(:status_updates).with_foreign_key("pharmacy_id") }
    it { is_expected.to have_many(:qr_scans) }
    it { is_expected.to have_many(:medication_intakes) }
  end

  describe 'enum' do
    it 'role に doctor, pharmacy, patient が定義されている' do
      expect(User.roles.keys).to contain_exactly("doctor", "pharmacy", "patient")
    end
  end

  describe 'コールバック' do
    it '患者を作成すると patient_number が自動採番される' do
      User.where(role: :patient).delete_all

      user1 = create(:user, :patient)
      expect(user1.patient_number).to eq(1)

      user2 = create(:user, :patient)
      expect(user2.patient_number).to eq(2)
    end

    it '医師を作成しても patient_number は nil のまま' do
      doctor = create(:user, :doctor)
      expect(doctor.patient_number).to be_nil
    end
  end
end

