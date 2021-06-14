class IdeasController < ApplicationController
  
  def index
    ideas = Idea.includes(:category)
    render json: ideas
  end

  def create
    categories = Category.all
    unless categories.exists?(name: idea_params[:name])
      Category.create(name: idea_params[:name])
    end
    category = categories.find_by(name: idea_params[:name])
    idea = Idea.new(category_id: category.id, body: idea_params[:body])
    if idea.save
      render status: 201
    else
      render status: 422
    end
  end

  private
  def idea_params
    params.permit(:name, :body)
  end
end
