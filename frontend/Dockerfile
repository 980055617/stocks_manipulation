FROM python:3.10.10

WORKDIR /frontend

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


COPY . .

CMD ["streamlit", "run", "app.py", "--server.port", "8501"]