FROM python:3.10.10

WORKDIR /backend

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade -r requirements.txt


COPY . .

CMD ["python", "plot_stocks.py"]