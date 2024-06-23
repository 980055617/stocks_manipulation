# frozen_string_literal: true

require 'bcrypt'
require 'sinatra'
require 'sqlite3'
require 'active_record'

enable :sessions

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "./db/users.db"
)

class Users < ActiveRecord::Base

end

class Holdings < ActiveRecord::Base

end

users = {
  'ryota' => BCrypt::Password.create('twins')
}

get '/' do
  @title = "stocks_manipulation"
  erb :index
end

get '/login/' do
  erb :login
end

post '/login/' do
  user = Users.where(username: params['username'], password: params['password']).count
  print user
  if user > 0
    session[:username] = params['username']
    redirect "/#{params['username']}/"
  else
    redirect '/login/'
  end
end

get '/register/' do
  erb :register
end

post '/register/' do
  username_count = Users.where(username: params['username']).count
  if username_count > 0
    redirect '/register/'
  else
    user = Users.create(
      username: params['username'],
      password: params['password']
    )
    holdings = Holdings.create([
                                 {}
                               ])
  end
end

get '/logout/' do
  session.clear
  redirect '/login/'
end

get '/secret/' do
  redirect '/login/' unless session[:username]
end

get '/:username/' do
  if session[:username] != params['username']
    redirect '/login/'
  end
  @messages = Holdings.where("id LIKE 'test'")
  erb :main_page
end
