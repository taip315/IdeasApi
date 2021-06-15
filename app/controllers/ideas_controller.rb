class IdeasController < ApplicationController
  before_action :all_categories, only: [:index, :create]
  def index
    category_name = permitted_params[:category_name]
    # category_nameが指定されていて、既に存在している場合
    if category_name.present? && @categories.exists?(name: category_name)
      ideas = Idea.includes(:category)
      @ideas = ideas.select { |idea| idea.category.name == category_name }
      render 'index', formats: :json, handlers: 'jbuilder'
    # category_nameが指定されているが、存在しない場合
    elsif category_name.present? && !@categories.exists?(name: category_name)
      render status: 404, json: { status: 404, message: ' Not Found' }
    # category_nameが指定されていない場合
    else
      @ideas = Idea.includes(:category)
      render 'index', formats: :json, handlers: 'jbuilder'
    end
  end

  def create
    # カテゴリー名が存在しなければ新たに作成する
    Category.create(name: post_params[:category_name]) unless @categories.exists?(name: post_params[:category_name])
    category = @categories.find_by(name: post_params[:category_name])

    # アイデアの登録。バリデーションで弾かれた場合、ステータスコード422を返す。
    idea = Idea.new(category_id: category.id, body: post_params[:body])

    if idea.save
      render json: idea, status: 201
    else
      render json: idea.errors, status: 422
    end
  end

  private

  def permitted_params
    params.permit(:category_name)
  end

  def post_params
    params.permit(:category_name, :body)
  end

  def all_categories
    @categories = Category.all
  end
end
