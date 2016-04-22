require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'nrg'
}

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || options)
