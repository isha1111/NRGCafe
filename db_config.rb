require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'nrg',
  username: 'isha'
}

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || options)
