require 'active_record'
require 'sinatra/activerecord/rake'
require './app'

namespace :db do
  desc "Create the database"
  task :create do
    ActiveRecord::Base.connection.create_database(YAML.load_file('config/database.yml')['development']['database'], {:charset => 'utf8'})
  end
end