from flask import Flask, request, jsonify
import yfinance as yf

app = Flask(__name__)

def get_stock_data(ticker_symbol, period):

    stock = yf.Ticker(ticker_symbol)
    data = stock.history(period=period)

    if data.empty:
        return None

    return data.reset_index().to_dict(orient='records')

@app.route('/stock', methods=['POST'])
def stock():

    req_data = request.get_json()


    ticker_symbol = req_data.get('stock_code')
    period = req_data.get('range', '1mo')

    if not ticker_symbol:
        return jsonify({"error": "stock_code is required"}), 400

    stock_data = get_stock_data(ticker_symbol, period)

    if stock_data is None:
        return jsonify({"error": f"No data found for ticker symbol {ticker_symbol}"}), 404

    return jsonify(stock_data)

if __name__ == '__main__':
    app.run_server(debug=True, host='0.0.0.0', port=8050)
