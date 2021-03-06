require 'rails_helper'

RSpec.describe Category, type: :model do
  before do
    @category = FactoryBot.build(:category)
  end

  describe '登録' do
    context '登録できるとき' do
      it 'nameがあれば登録できる' do
        expect(@category).to be_valid
      end
    end
    context '登録できないとき' do
      it 'nameが空だと登録できない' do
        @category.name = ' '
        @category.valid?
        expect(@category.errors.full_messages).to include("Name can't be blank")
      end
      it 'nameは重複して登録できない' do
        @unique_category = FactoryBot.create(:category)
        @another_category = FactoryBot.build(:category, name: @category_1.name)
        @category_2.valid?
        expect(@category_2.errors.full_messages).to include('Name has already been taken')
      end
    end
  end
end
