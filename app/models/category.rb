class Category < ApplicationRecord
  has_many :ideas

  validetes :name, presence: true, uniqueness: true
end
