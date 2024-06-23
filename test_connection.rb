require 'httparty'
require 'json'

url = "https://aa0c-2400-4151-121-2800-9179-5751-1abc-94e.ngrok-free.app/"
data = {stock_code: 'AAPL', range: '1mo'}

response = HTTParty.post(url, body: data.to_json, headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'})

puts "#{response.body}"