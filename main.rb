require 'sinatra'
require 'pg'
require 'sinatra/reloader'
require './db_config'
require 'pry'

require 'httparty'

require './models/user.rb'
require './models/dish.rb'
require './models/dish_type.rb'
@@order = []
@@menu = "menu"

enable :sessions

helpers do
	def current_user
		User.find_by(id: session[:user_id])
	end

	def logged_in?
	   !!current_user
	end

end

get '/' do
  erb :index
end

get '/menu' do
  @dish = Dish.all
  @@menu = "menu"
  erb :menu
end

get '/order/:id' do
  @dish = Dish.all
  @@order << params[:id]
  erb :menu
end

get '/cart' do
  erb :cart
end

get '/signin' do
  erb :login
end

post '/session' do
  user = User.find_by(email: params[:email])
	if user && user.authenticate(params[:password])
		#user exsits and password is correcct and page is redirected
		session[:user_id] = user.id
		redirect to '/'
	else
		#page is not redirected
		erb :login
	end
end

delete '/session' do
	session[:user_id] = nil
  @@order = []
	redirect to '/'
end

get '/Breakfast' do
  @@menu = "Breakfast"
  @dish = Dish.where(dish_type_id: 1)
  erb :menu
end

get '/Starter' do
  @@menu = "Starter"
  @dish = Dish.where(dish_type_id: 2)
  erb :menu
end

get '/Lunch' do
  @@menu = "Lunch"
  @dish = Dish.where(dish_type_id: 3)
  erb :menu
end

get '/Salad' do
  @@menu = "Salad"
  @dish = Dish.where(dish_type_id: 4)
  erb :menu
end

get '/Kids' do
  @@menu = "Kids"
  @dish = Dish.where(dish_type_id: 5)
  erb :menu
end

get '/cart' do
  erb :cart
end

post '/checkout' do
  if logged_in?
    erb :checkout
  else
    erb :login
  end
end

get '/securesession' do
  @user = current_user
  erb :securecheckout
end

get '/signup' do
  # User.create(username: params[:username],email: params[:email], password: params[:password])
  erb :new
end

post '/newuser' do
  @dish = Dish.all
  User.create(username: params[:username],email: params[:email], password: params[:password])
  erb :menu
end
