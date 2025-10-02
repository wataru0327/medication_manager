require 'rails_helper'

RSpec.describe Medication, type: :model do
  describe 'バリデーション' do
    context '正常系' do
      it '有効なデータなら保存できる' do
        medication = build(:medication, :with_image)
        expect(medication).to be_valid
      end

      it '用途が未設定でも保存できる' do
        medication = build(:medication, :with_image, purpose: :unspecified)
        expect(medication).to be_valid
      end
    end

    context '異常系' do
      it '薬名が空だと無効' do
        medication = build(:medication, :with_image, name: nil)
        expect(medication).not_to be_valid
        expect(medication.errors[:name]).to include("を入力してください")
      end

      it '用量が空だと無効' do
        medication = build(:medication, :with_image, dosage: nil)
        expect(medication).not_to be_valid
        expect(medication.errors[:dosage]).to include("を入力してください")
      end

      it '服用タイミングが空だと無効' do
        medication = build(:medication, :with_image, timing: nil)
        expect(medication).not_to be_valid
        expect(medication.errors[:timing]).to include("を入力してください")
      end

      it '画像が添付されていないと無効' do
        medication = build(:medication) # 画像なし
        expect(medication).not_to be_valid
        expect(medication.errors[:image]).to include("を選択してください")
      end
    end
  end
end

