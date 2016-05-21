require 'sinatra'
require 'pg'
require 'sinatra/flash'
require 'pony'
require 'httparty'

require './db_config'
require './models/user.rb'
require './models/dish.rb'
require './models/dish_type.rb'
require './models/order.rb'
require './models/dish_order.rb'
require './models/reservation.rb'

@@order = []

enable :sessions

# helpers to define methods
helpers do
	def current_user
		User.find_by(id: session[:user_id])
	end

	def logged_in?
	   !!current_user
	end

end

# shows the main page
get '/' do
  erb :index
end

# shows the menu page
get '/menu' do
  @dish = Dish.all
  @dishtype = DishType.all
  erb :menu
end

# shows the contact page
get '/contact' do
  erb :contact
end

# shows the confirmation page after the data has been submitted via form
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
	# flash the notice about the success
	flash[:notice] = "Your Enquiry has been submitted successfully!!"
	redirect to '/'
end

# shows the gallery page
get '/gallery' do
	@dish = Dish.all
	erb :gallery
end

# add dishes to cart if user is logged in or takes the user to login page
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

# shows the login page
get '/signin' do
  erb :login
end

# password recovery page
get '/signin/recovery' do
	erb :recovery
end

# sends email to rest password to user
get '/signin/recovery/confirmation' do
	user = User.find_by(email: params[:email])
	Pony.mail({
	:from => 'isha.negi19@gmail.com',
	:to => "#{params[:email]}",
	:subject => "Reset Password link for your account with cafe NRG",
	:body => "Your username is #{user.username} , please visit http://nrgcafe.herokuapp.com/resetPassword/#{params[:email]} to reset your password.",
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
	flash[:notice] = "Reset password email has been sent to your email"
	redirect to '/'
end

#  shows the screen for password reset
get '/resetPassword/:email' do
	erb :resetPassword
end

# update the password in database
post '/resetPassword' do
	user = User.find_by(email: params[:email])
	user.password = params[:password]
	user.save
	flash[:notice] = "Your Password has been Updated"
	redirect to '/'
end

# authenticate the user and logs them in otherwise redirects to same page and flash error
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

# delete session when logged out
delete '/session' do
	session[:user_id] = nil
  @@order = []
	redirect to '/'
end

# show the previous order placed by the user
get '/history' do
	@dish = Dish.all
	@user = current_user.username
	@order = Order.where(user_username: @user)
  erb :history
end

# adds the dish to cart and stores in variable @data
get '/menu/:id' do
  @dish = Dish.where(dish_type_id: params[:id])
  @dishtype = DishType.all
  erb :menu
end

# shows the cart page
get '/cart' do
  erb :cart
end

# shows the checkout page
post '/checkout' do
  if logged_in?
    erb :checkout
  else
    erb :login
  end
end

# asks the user if the wish to checkout and resirects to secure checkout page
get '/securesession/:total' do
  @user = current_user
  dish = []
	@total = params[:total].to_f * 100
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

# securely checkout the cart items and save the dat in database
post '/securesession/:total' do
	dish = []
	@@order.each do |id|
		dish << Dish.find_by(id: id).name
	end
	# send the confirmation mail to owner regarding order
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

# shows the sign up page
get '/signup' do
  # User.create(username: params[:username],email: params[:email], password: params[:password])
  erb :new
end

# creates the new user and save user in database
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

# delete items from cart
get '/delete/:id' do
  index = @@order.index(params[:id])
  @@order.delete_at(index)
  erb :cart
end

# shows the booking page
post '/reservation' do
	Pony.mail({
		:from => params[:email],
	  :to => 'isha.negi19@gmail.com',
	  :subject => "Table Reservation has been made!",
	  :body => "#{params[:name]} has made a reservation for #{params[:people]} people on #{params[:time]}. Please contact on number #{params[:phone]} for any enquiries",
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
	flash[:notice] = "Reservation has been made!!. Thank you "
	reservation = Reservation.new
	reservation.user_id = session[:user_id]
	reservation.name = params[:name]
	reservation.email = params[:email]
	reservation.phone = params[:phone]
	reservation.people = params[:people]
	reservation.date = params[:time]
	reservation.save
	redirect to '/'
end
