class Reservation < ActiveRecord::Base
  has_many :users
end
