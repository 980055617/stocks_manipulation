# frozen_string_literal: true

require 'bcrypt'
require 'sinatra'
require 'sqlite3'
require 'active_record'
require 'httparty'
require 'json'

enable :sessions

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "./db/users.db"
)

class Users < ActiveRecord::Base

end

class Holdings < ActiveRecord::Base

end

class BrandList < ActiveRecord::Base

end

class StockValueWeek < ActiveRecord::Base

end

class StockValueMonth < ActiveRecord::Base

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
    user_holdings.each do |user_holding|
      holding_is_registered = BrandList.where(brand_name: user_holding.brand_name)
      if holding_is_registered.count == 0
        url = "http://127.0.0.1:8050/stock"
        data = {stock_code: user_holding.brand_name, range: "1mo"}
        print data
        response = HTTParty.post(url, body: data.to_json, headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'})
        response_data = JSON.parse(response.body)
        count_val = 1
        response_data.each do |data_per_day|
          print user_holding.brand_name
          svm = StockValueMonth.create({brand_name: user_holding.brand_name, order_no: count_val, time: data_per_day["Date"], high: data_per_day["High"], low: data_per_day["Low"], open: data_per_day["Open"], close: data_per_day["Close"]})
          count_val += 1
        end
        new_brand_list = BrandList.create({brand_name: user_holding.brand_name})
      end
    end
    session[:username] = params['username']
    redirect "/#{params['username']}/"
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
  holdings = Holdings.where("username LIKE '#{params['username']}'")
  message = []
  holdings.each do |holding|
    message.push(
      StockValueMonth.where(brand_name: holding.brand_name)
    )
  end
  @message = message
  print @message
  erb :main_page
end
