require 'rails_helper'

RSpec.describe MedicationIntake, type: :model do
  describe 'バリデーション' do
    context '正常系' do
      it 'ユーザー・処方箋アイテム・服薬日時が揃っていれば有効' do
        intake = build(:medication_intake)
        expect(intake).to be_valid
      end
    end

    context '異常系' do
      it 'taken_at が空だと無効' do
        intake = build(:medication_intake, taken_at: nil)
        expect(intake).not_to be_valid
        expect(intake.errors[:taken_at]).to include("を入力してください")
      end

      it 'user が紐付いていないと無効' do
        intake = build(:medication_intake, user: nil)
        expect(intake).not_to be_valid
        expect(intake.errors[:user]).to include("を入力してください")
      end

      it 'prescription_item が紐付いていないと無効' do
        intake = build(:medication_intake, prescription_item: nil)
        expect(intake).not_to be_valid
        expect(intake.errors[:prescription_item]).to include("を入力してください")
      end
    end
  end

  describe '関連付け' do
    it { should belong_to(:user) }
    it { should belong_to(:prescription_item) }
  end
end

