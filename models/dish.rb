class Dish < ActiveRecord::Base
  belongs_to :dish_type
  has_many :orders, through: :dish_orders
  has_many :dish_orders
end
