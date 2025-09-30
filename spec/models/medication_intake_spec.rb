require 'rails_helper'

RSpec.describe MedicationIntake, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:taken_at) }
  end

  describe '関連付け' do
    it { should belong_to(:user) }
    it { should belong_to(:prescription_item) }
  end

  describe '有効なデータ' do
    it '正しいデータなら有効' do
      intake = build(:medication_intake)
      expect(intake).to be_valid
    end

    it 'taken_at が空なら無効' do
      intake = build(:medication_intake, taken_at: nil)
      expect(intake).not_to be_valid
      expect(intake.errors[:taken_at]).to be_present
    end
  end
end
