class Dish < ActiveRecord::Base
  belongs_to :dishes
  has_many :users
end
