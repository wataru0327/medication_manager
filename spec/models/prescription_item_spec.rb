require 'rails_helper'

RSpec.describe PrescriptionItem, type: :model do
  describe 'バリデーション' do
    it { should validate_numericality_of(:days).only_integer.is_greater_than(0) }
  end

  describe '関連付け' do
    it { should belong_to(:prescription) }
    it { should belong_to(:medication) }
    it { should have_many(:medication_intakes).dependent(:destroy) }
  end

  describe '有効なデータ' do
    it '正しい値なら有効' do
      item = build(:prescription_item, days: 10)
      expect(item).to be_valid
    end

    it 'days が 0 以下なら無効' do
      item = build(:prescription_item, days: 0)
      expect(item).not_to be_valid
      expect(item.errors[:days]).to be_present
    end

    it 'days が整数以外なら無効' do
      item = build(:prescription_item, days: 2.5)
      expect(item).not_to be_valid
      expect(item.errors[:days]).to be_present
    end
  end
end
