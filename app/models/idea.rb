class Idea < ApplicationRecord
  belongs_to :category
  validates :category_id, :body, presence: true
end
