require 'rails_helper'

RSpec.describe Medication, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:dosage) }
    it { should validate_presence_of(:timing) }
  end

  describe 'enum' do
    it 'timing に morning, noon, evening, bedtime, after_meal が定義されている' do
      expect(Medication.timings.keys).to contain_exactly("morning", "noon", "evening", "bedtime", "after_meal")
    end

    it 'purpose に unspecified, antipyretic, analgesic, stomach, antibiotic が定義されている' do
      expect(Medication.purposes.keys).to contain_exactly("unspecified", "antipyretic", "analgesic", "stomach", "antibiotic")
    end
  end

  describe '有効なデータ' do
    it '正しいデータなら有効' do
      medication = build(:medication)
      expect(medication).to be_valid
    end

    it '名前が空なら無効' do
      medication = build(:medication, name: nil)
      expect(medication).not_to be_valid
      expect(medication.errors[:name]).to be_present
    end

    it '用量が空なら無効' do
      medication = build(:medication, dosage: nil)
      expect(medication).not_to be_valid
      expect(medication.errors[:dosage]).to be_present
    end

    it 'timing が空なら無効' do
      medication = build(:medication, timing: nil)
      expect(medication).not_to be_valid
      expect(medication.errors[:timing]).to be_present
    end
  end
end
