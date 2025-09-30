require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  it 'ActiveRecord::Base を継承している' do
    expect(ApplicationRecord < ActiveRecord::Base).to be true
  end

  it '抽象クラスである' do
    expect(ApplicationRecord.abstract_class).to be true
  end
end
