FROM python:3.11
WORKDIR /code
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app.py .
CMD ["uvicorn", "app:api", "--host", "0.0.0.0", "--port", "8000"]
