require 'rails_helper'

RSpec.describe Idea, type: :model do
  before do
    @idea = FactoryBot.build(:idea)
  end

  describe 'アイデア登録' do
    context '登録できるとき' do
      it 'category_id、bodyがあれば登録できる' do
        expect(@idea).to be_valid
      end
    end
    context '登録できないとき' do
      it 'bodyが空だと登録できない' do
        @idea.body = ' '
        @idea.valid?
        expect(@idea.errors.full_messages).to include("Body can't be blank")
      end
    end
  end
end
