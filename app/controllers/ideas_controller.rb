class IdeasController < ApplicationController
  
  def index
    ideas = Idea.includes(:category)
    render json: ideas
  end

  def create
    categories = Category.all
    unless categories.exists?(name: idea_params[:category_name])
      Category.create(name: idea_params[:category_name])
    end
    category = categories.find_by(name: idea_params[:category_name])
    idea = Idea.new(category_id: category.id, body: idea_params[:body])
    if idea.save
      render json: idea, status: 201
    else
      render json: user.errors, status: 422
    end
  end

  private
  def idea_params
    params.permit(:category_name, :body)
  end
end
