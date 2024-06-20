import yfinance as yf
import plotly.graph_objs as go
from plotly.subplots import make_subplots
import dash
from dash import dcc, html
from dash.dependencies import Input, Output
import math
from flask_caching import Cache

def read_config(file_path):
    symbols = []
    names = []
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.read().splitlines()
        for line in lines:
            symbol, name = line.split(',')
            symbols.append(symbol)
            names.append(name)
    return symbols, names

stock_symbols, stock_names = read_config('config.txt')

app = dash.Dash(__name__)
cache = Cache(app.server, config={'CACHE_TYPE': 'SimpleCache'})
TIMEOUT = 3600  # Cache timeout in seconds

app.layout = html.Div([
    dcc.Input(id='input-width', type='number', value=1000, style={'marginRight': '10px'}),
    html.Button('Update', id='update-button', n_clicks=0),
    dcc.Dropdown(
        id='period-dropdown',
        options=[
            {'label': '5 Days', 'value': '5d'},
            {'label': '1 Month', 'value': '1mo'},
            {'label': '3 Months', 'value': '3mo'}
        ],
        value='3mo',
        clearable=False,
        style={'marginRight': '10px', 'marginTop': '10px'}
    ),
    dcc.Interval(id='interval-component', interval=1*3600*1000, n_intervals=0),  # Update every hour
    dcc.Graph(id='stock-graph')
])

@cache.memoize(timeout=TIMEOUT)
def fetch_stock_data(symbol):
    stock = yf.Ticker(symbol)
    return stock.history(period="3mo")  # Fetch the last 3 months of data

@app.callback(
    Output('stock-graph', 'figure'),
    [Input('update-button', 'n_clicks'), Input('interval-component', 'n_intervals'), Input('period-dropdown', 'value')],
    [Input('input-width', 'value')]
)
def update_graph(n_clicks, n_intervals, period, width):
    cols = max(1, width // 250)
    rows = math.ceil(len(stock_symbols) / cols)
    fig = make_subplots(rows=rows, cols=cols, subplot_titles=stock_names)

    for i, (symbol, name) in enumerate(zip(stock_symbols, stock_names)):
        hist = fetch_stock_data(symbol)

        if period == '5d':
            hist = hist[-5:]
        elif period == '1mo':
            hist = hist[-22:]  # Approximate 22 trading days in a month
        elif period == '3mo':
            hist = hist  # Already the last 3 months

        row = i // cols + 1
        col = i % cols + 1

        fig.add_trace(
            go.Scatter(x=hist.index, y=hist['Close'], mode='lines+markers', name=symbol),
            row=row, col=col
        )

        fig.update_xaxes(title_text="Date", row=row, col=col)
        fig.update_yaxes(title_text="Close Price (USD)", row=row, col=col)

    fig.update_layout(height=300 * rows, title_text="Stock Prices for the Selected Period", showlegend=False)
    return fig

if __name__ == '__main__':
    app.run_server(debug=True)
