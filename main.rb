require 'sinatra'
require 'pg'
require './db_config'
require 'pry'
require 'sinatra/flash'
require 'sinatra/reloader'
require 'pony'
require 'httparty'

require './models/user.rb'
require './models/dish.rb'
require './models/dish_type.rb'
require './models/order.rb'
require './models/dish_order.rb'

@@order = []

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
  @dishtype = DishType.all
  erb :menu
end

get '/contact' do
  erb :contact
end
post '/contact' do
	Pony.mail({
:from => params[:email],
  :to => 'isha.negi19@gmail.com',
  :subject => "Enquiry has been submitted!",
  :body => "#{params[:fname]} has made an enquiry. Please contact on number #{params[:phone]}",
  :via => :smtp,
  :via_options => {
   :address              => 'smtp.gmail.com',
   :port                 => '587',
   :enable_starttls_auto => true,
   :user_name            => 'johnmann778@gmail.com',
   :password             => 'password18*',
   :authentication       => :plain,
   :domain               => "localhost.localdomain"
   }
  })
	flash[:notice] = "Your Enquiry has been submitted successfully!!"
	redirect to '/'
end

get '/gallery' do
	erb :gallery
end

get '/order/:id' do
  if logged_in?
      @dish = Dish.all
      @dishtype = DishType.all
      @@order << params[:id]
      erb :menu
    else
      erb :login
    end
end

get '/signin' do
  erb :login
end

post '/session' do
  user = User.find_by(username: params[:username])
	if user && user.authenticate(params[:password])
		#user exsits and password is correcct and page is redirected
		session[:user_id] = user.id
		redirect to '/'
	else
		#page is not redirected
		flash[:notice] = "Username or Password is Incorrect !!"
		redirect to '/signin'
	end
end

delete '/session' do
	session[:user_id] = nil
  @@order = []
	redirect to '/'
end

get '/history' do
	@dish = Dish.all
	@user = current_user.username
	@order = Order.where(user_username: @user)
  erb :history
end

get '/menu/:id' do
  @dish = Dish.where(dish_type_id: params[:id])
  @dishtype = DishType.all
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

get '/securesession/:total' do
  @user = current_user
  dish = []
	@total = params[:total].to_f
  @@order.each do |id|
    dish << Dish.find_by(id: id).name
  end
  order = Order.new
	order.user_username = @user.username
	order.time = Time.now.strftime("%d/%m/%Y %H:%M")
	@@order.each do |id|
	order.dishes << Dish.find(id)
	end
	order.save
  erb :securecheckout
end

post '/securesession/:total' do

	dish = []
	@@order.each do |id|
		dish << Dish.find_by(id: id).name
	end
	Pony.mail({
	:from => current_user.username,
	:to => 'isha.negi19@gmail.com',
	:subject => "Cafe NRG - Order has been made!!",
	:body => "#{current_user.username} has made an order for #{dish.join(",")}",
	:via => :smtp,
	:via_options => {
	 :address              => 'smtp.gmail.com',
	 :port                 => '587',
	 :enable_starttls_auto => true,
	 :user_name            => 'johnmann778@gmail.com',
	 :password             => 'password18*',
	 :authentication       => :plain,
	 :domain               => "localhost.localdomain"
	 }
	})
	@@order = []
	flash[:notice] = "Order placed successfully !!"
	redirect to '/'
end

get '/signup' do
  # User.create(username: params[:username],email: params[:email], password: params[:password])
  erb :new
end

post '/newuser' do
  @dish = Dish.all
	@dishtype = DishType.all
	u = User.new
	u.username = params[:username]
	u.password = params[:password]
	u.email =params[:email]
	u.save
  # user = User.create(username: params[:username],email: params[:email], password: params[:password])
	if u.valid?
		user = User.find_by(username: params[:username])
		session[:user_id] = user.id
		erb :menu
	else
		flash[:error] = "Username Already Exists"
		redirect to '/signup'
	end

  # if user && user.authenticate(params[:password])
  #   #user exsits and password is correcct and page is redirected
  #   session[:user_id] = user.id
	# 	erb :menu
  # else
  #   erb :new
  # end

end

get '/delete/:id' do
  index = @@order.index(params[:id])
  @@order.delete_at(index)
  erb :cart
end
