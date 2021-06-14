class IdeasController < ApplicationController
  before_action :get_categories
  def index
    category_name = get_params[:category_name]
    if category_name.present? && categories.exists?(name: category_name)
      ideas = Idea.includes(:category)
      @ideas = ideas.select{|idea|idea.category.name == category_name}
    elsif category_name.present? && !categories.exists?(name: category_name)
      render status: 404
    else
      @ideas = Idea.includes(:category)
    end
  end

  def create
    unless categories.exists?(name: post_params[:category_name])
      Category.create(name: post_params[:category_name])
    end
    category = categories.find_by(name: post_params[:category_name])
    idea = Idea.new(category_id: category.id, body: post_params[:body])
    if idea.save
      render json: idea, status: 201
    else
      render json: idea.errors, status: 422
    end
  end


  private
  def get_params
    params.permit(:category_name)
  end
  
  def post_params
    params.permit(:category_name, :body)
  end

  def get_categories
    categories = Category.all
  end
end
