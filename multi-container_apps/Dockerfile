# Dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY . /app

# COPY requirements.txt /app
# RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir flask


EXPOSE 5000

ENV FLASK_APP=app.py


CMD flask run -h 0.0.0.0 -p 5000
