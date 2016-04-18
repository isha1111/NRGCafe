require 'sinatra'
require 'pg'
require 'sinatra/reloader'
require './db_config'

require './models/user.rb'
require './models/dish.rb'
require './models/dish_type.rb'

get '/' do
  erb :index
end

get '/menu' do
  @dish = Dish.all
  erb :menu
end
