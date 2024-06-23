# frozen_string_literal: true

require 'bcrypt'
require 'sinatra'
require 'sequel'
require 'sqlite3'
require 'active_record'

enable :sessions

ActiveRecord::Base.establish_connection(YAML.load_file('config/database.yml')['development'])

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

get '/login' do
  "Hello World"
end

post '/login/' do
  user = users[params['username']]
  if user && BCrypt::Password.new(user) == params['password']
    session[:username] = params['username']
    redirect "/#{params['username']}/"
  else
    redirect '/login/'
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

  erb :main_page
end
