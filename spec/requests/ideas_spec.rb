require 'rails_helper'

RSpec.describe 'Ideas', type: :request do
  describe 'アイデア取得機能' do
    before do
      @ideas = FactoryBot.create_list(:idea, 10)
    end

    describe 'GET /ideas（クエリパラメータなし）' do
      before do
        get '/ideas'
      end

      it '正常にレスポンスが返ってくる' do
        expect(response.status).to eq(200)
      end

      it 'データ一覧を取得できる' do
        json = JSON.parse(response.body)
        expect(json['data'].length).to eq(10)
      end
    end

    describe 'GET /ideas（クエリパラメータあり）' do
      before do
        @category = FactoryBot.create(:category)
        @ideas_true = FactoryBot.create_list(:idea, 2, category_id: @category.id)
      end
      context '取得できるとき' do
        before do
          get '/ideas', params: { category_name: @category.name }
        end
        it '正常にレスポンスが返ってくる' do
          expect(response.status).to eq(200)
        end
        it 'パラメータで指定したカテゴリのデータが取得できる' do
          json = JSON.parse(response.body)['data']
          expect(json.length).to eq(2)
          expect(json[0]['category']).to eq(@category.name)
          expect(json[1]['category']).to eq(@category.name)
        end
      end
      context '取得できないとき' do
        it 'パラメータが指定したカテゴリが存在しない場合、データの取得ができない' do
          get '/ideas', params: { category_name: 'テスト' }
          expect(response.status).to eq(404)
        end
      end
    end
  end

  describe 'アイデア登録機能' do
    before do
      @categories = FactoryBot.create_list(:category, 10)
    end

    context '登録できるとき' do
      it 'リクエストのcategory_nameがcategoriesテーブルのnameに存在する場合' do
        valid_params = { idea: { category_name: @categories[0].name, body: 'テスト' } }
        expect { post '/ideas', params: valid_params }.to change(Idea, :count).by(+1)
        expect(response.status).to eq(201)
      end
      it 'リクエストのcategory_nameがcategoriesテーブルのnameに存在しない場合' do
        valid_params = { idea: { category_name: 'テスト', body: 'テスト' } }
        expect { post '/ideas', params: valid_params }.to change(Idea, :count).by(+1)
        expect(response.status).to eq(201)
      end
    end

    context '登録できないとき' do
      it 'リクエストにbodyがない場合' do
        valid_params = { idea: { category_name: 'テスト', body: '' } }
        post '/ideas', params: valid_params
        expect(response.status).to eq(422)
      end
    end
  end
end
