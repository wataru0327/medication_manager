require 'rails_helper'

RSpec.describe StatusUpdate, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:prescription_id) }
    it { should validate_presence_of(:status) }
  end

  describe '関連付け' do
    it { should belong_to(:prescription) }
    it { should belong_to(:pharmacy).class_name('User').optional }
  end

  describe 'enum' do
    it 'status に pending, accepted, processing, completed が定義されている' do
      expect(StatusUpdate.statuses.keys).to contain_exactly(
        "pending", "accepted", "processing", "completed"
      )
    end
  end

  describe '#status_label' do
    let(:prescription) { create(:prescription) }  # ✅ Factory で必須項目を用意

    it 'pending のとき「患者が保有中」を返す' do
      update = build(:status_update, prescription: prescription, status: :pending)
      expect(update.status_label).to eq("患者が保有中")
    end

    it 'accepted のとき「受付済み」を返す' do
      update = build(:status_update, prescription: prescription, status: :accepted)
      expect(update.status_label).to eq("受付済み")
    end

    it 'processing のとき「調剤中」を返す' do
      update = build(:status_update, prescription: prescription, status: :processing)
      expect(update.status_label).to eq("調剤中")
    end

    it 'completed のとき「完了」を返す' do
      update = build(:status_update, prescription: prescription, status: :completed)
      expect(update.status_label).to eq("完了")
    end
  end
end

