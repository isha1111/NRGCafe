
require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDERR)

require './db_config'
require './models/dish'
require './models/dish_type'
require './models/user'
require './models/order.rb'
require './models/dish_order.rb'
require './models/reservation.rb'
