class Order < ActiveRecord::Base
  has_many :dishes, through: :dish_orders
  has_many :dish_orders
end
