require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    context '正常系' do
      it '有効なデータなら保存できる' do
        user = build(:user, name: "テストユーザー", email: "test@example.com", password: "password")
        expect(user).to be_valid
      end

      it 'patient_number が nil でも保存できる（doctor や pharmacy の場合）' do
        user = build(:user, :doctor, patient_number: nil)
        expect(user).to be_valid
      end

      it 'patient_number が整数なら保存できる' do
        user = build(:user, :patient, patient_number: 100)
        expect(user).to be_valid
      end
    end

    context '異常系' do
      it 'name が空だと無効' do
        user = build(:user, name: nil)
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("を入力してください")
      end

      it 'email が空だと無効' do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("を入力してください")
      end

      it 'email が重複すると無効' do
        create(:user, email: "duplicate@example.com")
        user = build(:user, email: "duplicate@example.com")
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("はすでに使用されています") 
      end

      it 'patient_number が重複すると無効' do
        create(:user, :patient, patient_number: 1)
        user = build(:user, :patient, patient_number: 1)
        expect(user).not_to be_valid
        expect(user.errors[:patient_number]).to include("はすでに使用されています") 
      end

      it 'patient_number が整数以外だと無効' do
        user = build(:user, :patient, patient_number: "abc")
        expect(user).not_to be_valid
        expect(user.errors[:patient_number]).to include("は数値で入力してください")
      end
    end
  end
end


