# Use the official Python image as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the application code into the container
COPY . /app

# Install the dependencies
RUN pip3 install --no-cache-dir flask

# Expose the port the app runs on
EXPOSE 5000


# Define environment variable
ENV FLASK_APP=app.py


# Define the command to run the app
# CMD ["flask", "run", "--host=0.0.0.0", "--port=5050"]
CMD flask run -h 0.0.0.0 -p 5000