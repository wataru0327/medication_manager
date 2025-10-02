require 'rails_helper'

RSpec.describe StatusUpdate, type: :model do
  describe 'バリデーション' do
    context '正常系' do
      it '有効なデータなら保存できる' do
        prescription = create(:prescription) 
        status_update = build(:status_update, prescription: prescription, status: :pending)
        expect(status_update).to be_valid
      end

      it 'pharmacy がなくても保存できる（optional: true）' do
        prescription = create(:prescription)
        status_update = build(:status_update, prescription: prescription, status: :accepted, pharmacy: nil)
        expect(status_update).to be_valid
      end
    end

    context '異常系' do
      it 'prescription が空だと無効' do
        status_update = build(:status_update, prescription: nil, status: :pending)
        expect(status_update).not_to be_valid
        expect(status_update.errors[:prescription]).to include("を入力してください")
      end

      it 'status が空だと無効' do
        prescription = create(:prescription)
        status_update = build(:status_update, prescription: prescription, status: nil)
        expect(status_update).not_to be_valid
        expect(status_update.errors[:status]).to include("を入力してください")
      end

      it 'status に不正な値を設定すると無効' do
        prescription = create(:prescription)
        expect {
          build(:status_update, prescription: prescription, status: "unknown")
        }.to raise_error(ArgumentError) 
      end
    end
  end

  describe '#status_label' do
    let(:prescription) { create(:prescription) }

    it 'pending の場合は「患者が保有中」を返す' do
      status_update = build(:status_update, prescription: prescription, status: :pending)
      expect(status_update.status_label).to eq("患者が保有中")
    end

    it 'completed の場合は「完了」を返す' do
      status_update = build(:status_update, prescription: prescription, status: :completed)
      expect(status_update.status_label).to eq("完了")
    end
  end
end

