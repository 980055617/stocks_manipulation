require 'sqlite3'
require 'dotenv/load'

# データベースの作成とテーブルの作成
def create_database_and_tables
  # ログインユーザーの識別子とアカウントとパスワードのデータベース
  login_db = SQLite3::Database.new ENV['LOGIN_DB_PATH']
  login_db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY,
      username TEXT NOT NULL,
      password TEXT NOT NULL
    );
  SQL

  # ユーザーごとの登録している株の銘柄のデータベース
  user_stocks_db = SQLite3::Database.new ENV['USER_STOCKS_DB_PATH']
  user_stocks_db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS user_stocks (
      id INTEGER PRIMARY KEY,
      user_id INTEGER,
      stock_symbol TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id)
    );
  SQL

  # 登録している株とその1か月のhighとlowの情報(毎日)のデータベース
  monthly_stocks_db = SQLite3::Database.new ENV['MONTHLY_STOCKS_DB_PATH']
  monthly_stocks_db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS monthly_stock_data (
      id INTEGER PRIMARY KEY,
      stock_symbol TEXT NOT NULL,
      date TEXT NOT NULL,
      high REAL,
      low REAL
    );
  SQL

  # 登録している株とその5日のhighとlowの情報(毎時間)のデータベース
  daily_stocks_db = SQLite3::Database.new ENV['DAILY_STOCKS_DB_PATH']
  daily_stocks_db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS daily_stock_data (
      id INTEGER PRIMARY KEY,
      stock_symbol TEXT NOT NULL,
      timestamp TEXT NOT NULL,
      high REAL,
      low REAL
    );
  SQL

  # 現在データベースに入っているすべての株の銘柄のデータベース
  all_stocks_db = SQLite3::Database.new ENV['ALL_STOCKS_DB_PATH']
  all_stocks_db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS all_stocks (
      id INTEGER PRIMARY KEY,
      stock_symbol TEXT NOT NULL UNIQUE
    );
  SQL

  puts "Databases and tables created successfully"
end

create_database_and_tables
