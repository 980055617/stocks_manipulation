require 'httparty'
require 'json'

url = "http://127.0.0.1:8050/stock"
data = {stock_code: 'AAPL', range: '1mo'}

response = HTTParty.post(url, body: data.to_json, headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'})

puts "#{response.body}"
