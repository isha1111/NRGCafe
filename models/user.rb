class User < ActiveRecord::Base
  has_many :orders
  validates :email, presence: true
  validates :username, uniqueness: true, presence: true
  has_secure_password
end
