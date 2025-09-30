require 'rails_helper'

RSpec.describe QrScan, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:token) }
  end

  describe '関連付け' do
    it { should belong_to(:user) }
    it { should belong_to(:prescription) }
  end
end
