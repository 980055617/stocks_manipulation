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
                                 {username: params['username'], order_no: 1, brand_name: params['brand1']},
                                 {username: params['username'], order_no: 2, brand_name: params['brand2']},
                                 {username: params['username'], order_no: 3, brand_name: params['brand3']},
                                 {username: params['username'], order_no: 4, brand_name: params['brand4']},
                                 {username: params['username'], order_no: 5, brand_name: params['brand5']},
                                 {username: params['username'], order_no: 6, brand_name: params['brand6']},
                                 {username: params['username'], order_no: 7, brand_name: params['brand7']},
                                 {username: params['username'], order_no: 8, brand_name: params['brand8']},
                                 {username: params['username'], order_no: 9, brand_name: params['brand9']},
                               ])

    # データベースへの登録
    user_holdings = Holdings.where(username: params['username'])
    for user_holding in user_holdings
      holding_name = user_holding.brand_name

    end
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
  @messages = Holdings.where("username LIKE '#{params['username']}'")
  erb :main_page
end
