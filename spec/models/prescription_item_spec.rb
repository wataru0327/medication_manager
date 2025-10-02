require 'rails_helper'

RSpec.describe PrescriptionItem, type: :model do
  describe 'バリデーション' do
    context '正常系' do
      it '有効なデータなら保存できる' do
        item = build(:prescription_item, days: 7)
        expect(item).to be_valid
      end

      it 'days が1以上の整数なら有効' do
        item = build(:prescription_item, days: 1)
        expect(item).to be_valid
      end
    end

    context '異常系' do
      it 'days が0以下だと無効' do
        item = build(:prescription_item, days: 0)
        expect(item).not_to be_valid
        expect(item.errors[:days]).to be_present
      end

      it 'days が小数だと無効' do
        item = build(:prescription_item, days: 2.5)
        expect(item).not_to be_valid
        expect(item.errors[:days]).to be_present
      end

      it 'days が文字列だと無効' do
        item = build(:prescription_item, days: "abc")
        expect(item).not_to be_valid
        expect(item.errors[:days]).to be_present
      end

      it 'prescription が存在しないと無効' do
        item = build(:prescription_item, prescription: nil)
        expect(item).not_to be_valid
        expect(item.errors[:prescription]).to be_present
      end

      it 'medication が存在しないと無効' do
        item = build(:prescription_item, medication: nil)
        expect(item).not_to be_valid
        expect(item.errors[:medication]).to be_present
      end
    end
  end

  describe '関連付け' do
    it { should belong_to(:prescription) }
    it { should belong_to(:medication) }
    it { should have_many(:medication_intakes).dependent(:destroy) }
  end
end
