# Dockerfile

FROM python:3.9
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
# CMD ["python", "app.py"]
CMD flask run -h 0.0.0.0 -p 5000