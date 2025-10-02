require 'rails_helper'

RSpec.describe QrScan, type: :model do
  describe 'バリデーション' do
    context '正常系' do
      it '有効なデータなら保存できる' do
        user = create(:user, :patient)
        prescription = create(:prescription)
        qr_scan = build(:qr_scan, user: user, prescription: prescription, token: "sample-token")
        expect(qr_scan).to be_valid
      end
    end

    context '異常系' do
      it 'user が存在しないと無効' do
        prescription = create(:prescription)
        qr_scan = build(:qr_scan, user: nil, prescription: prescription, token: "sample-token")
        expect(qr_scan).not_to be_valid
        expect(qr_scan.errors[:user]).to include("を入力してください")
      end

      it 'prescription が存在しないと無効' do
        user = create(:user, :patient)
        qr_scan = build(:qr_scan, user: user, prescription: nil, token: "sample-token")
        expect(qr_scan).not_to be_valid
        expect(qr_scan.errors[:prescription]).to include("を入力してください")
      end

      it 'token が空だと無効' do
        user = create(:user, :patient)
        prescription = create(:prescription)
        qr_scan = build(:qr_scan, user: user, prescription: prescription, token: nil)
        expect(qr_scan).not_to be_valid
        expect(qr_scan.errors[:token]).to include("を入力してください")
      end
    end
  end
end

